# This module has been tested with Terraform 0.12 only.
#
# Note: GCS backend requires the current user to have valid application-default
# credentials. An error like "... failed: dialing: google: could not find default
# credenitals" indicates that the calling user must (re-)authenticate application
# default credentials using `gcloud auth application-default login`.
terraform {
  required_version = "~> 0.12"
  # The location and path for GCS state storage must be specified in an environment
  # file(s) via `-backend-config=env/ENV/automation-factory.config"
  backend "gcs" {}
}

# Provider and Terraform service acocunt impersonation is handled in providers.tf

# Make sure the subnets are all good
data "google_compute_subnetwork" "subnets" {
  for_each  = toset(var.subnets)
  self_link = each.value
}

locals {
  # All subnets should have the same region, use the first subnet's region as the target region
  region = element(compact(distinct([for subnet in data.google_compute_subnetwork.subnets : subnet.region])), 0)
  metadata = merge(var.metadata, {
    enable-oslogin = upper(var.enable_os_login)
    user-data = templatefile("${path.module}/templates/cloud-config.tpl", {
    })
  })
  nic0_network = [for subnet in data.google_compute_subnetwork.subnets : subnet.network][0]
}

# Create service account for webapp vm
module "service_accounts" {
  source     = "terraform-google-modules/service-accounts/google"
  version    = "2.0.2"
  project_id = var.project_id
  names      = ["webapp"]
  project_roles = [
    "${var.project_id}=>roles/logging.logWriter",
    "${var.project_id}=>roles/monitoring.metricWriter",
    "${var.project_id}=>roles/monitoring.viewer"
  ]
  generate_keys = false
}

# Add a health check firewall rule on nic0
resource "google_compute_firewall" "mig_hc" {
  project     = var.project_id
  name        = "webapp-allow-rmig-hc"
  network     = local.nic0_network
  description = "Allow RMIG health check"
  direction   = "INGRESS"
  source_ranges = [
    "35.191.0.0/16",
    "130.211.0.0/22",
  ]
  target_service_accounts = [
    module.service_accounts.emails["webapp"],
  ]
  allow {
    protocol = "TCP"
    ports = [
      "80",
    ]
  }
}

# Allow IAP on nic0
resource "google_compute_firewall" "iap" {
  project     = var.project_id
  name        = "webapp-allow-iap"
  network     = local.nic0_network
  description = "Allow IAP tunnelling to webapp"
  direction   = "INGRESS"
  source_ranges = [
    "35.235.240.0/20",
  ]
  target_service_accounts = [
    module.service_accounts.emails["webapp"],
  ]
  allow {
    protocol = "TCP"
    ports = [
      "22",
      "80",
    ]
  }
}

# Allow port 80 on all networks
resource "google_compute_firewall" "http" {
  for_each    = toset(distinct(compact([for subnet in data.google_compute_subnetwork.subnets : subnet.network])))
  project     = var.project_id
  name        = "webapp-allow-http-${regex(".*/(.+)$", each.value)[0]}"
  network     = each.value
  description = "Allow HTTP to webapp"
  direction   = "INGRESS"
  source_ranges = [
    "0.0.0.0/0",
  ]
  target_service_accounts = [
    module.service_accounts.emails["webapp"],
  ]
  allow {
    protocol = "TCP"
    ports = [
      "80",
    ]
  }
}

resource "google_compute_instance_template" "webapp" {
  project              = var.project_id
  name_prefix          = "webapp-multi-nic-"
  description          = "Template for multi-nic webapp"
  instance_description = "Multi-nic webapp"
  region               = local.region

  metadata = local.metadata
  labels   = var.labels
  tags     = var.tags

  machine_type = var.machine_type
  service_account {
    email  = module.service_accounts.emails["webapp"]
    scopes = []
  }

  scheduling {
    automatic_restart = ! var.preemptible
    preemptible       = var.preemptible
  }

  disk {
    auto_delete  = true
    boot         = true
    type         = "PERSISTENT"
    disk_type    = var.disk_type
    disk_size_gb = var.disk_size_gb
    source_image = var.source_image
  }

  dynamic "network_interface" {
    for_each = data.google_compute_subnetwork.subnets
    content {
      subnetwork         = network_interface.value["name"]
      subnetwork_project = network_interface.value["project"]
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_health_check" "webapp" {
  project            = var.project_id
  name               = "webapp-rmig-hc"
  timeout_sec        = 1
  check_interval_sec = 30
  http_health_check {
    port         = 80
    request_path = "/"
  }
}

resource "google_compute_region_instance_group_manager" "webapp" {
  project            = var.project_id
  name               = "webapp-rmig-${local.region}"
  description        = "Regional MIG for webapp instances in ${local.region}"
  region             = local.region
  base_instance_name = "webapp"
  target_size        = var.target_size
  wait_for_instances = false

  version {
    name              = google_compute_instance_template.webapp.name
    instance_template = google_compute_instance_template.webapp.self_link
  }

  auto_healing_policies {
    health_check      = google_compute_health_check.webapp.self_link
    initial_delay_sec = var.auto_healing_initial_delay_sec
  }

  update_policy {
    type                  = var.update_policy_type
    minimal_action        = var.update_policy_minimal_action
    max_surge_fixed       = var.update_policy_max_surge_fixed
    max_unavailable_fixed = var.update_policy_max_unavailable_fixed
    min_ready_sec         = var.update_policy_min_ready_sec
  }

  lifecycle {
    create_before_destroy = true
  }
}
