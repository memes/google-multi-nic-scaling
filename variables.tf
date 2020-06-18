variable "tf_sa_email" {
  type        = string
  description = <<EOD
The fully-qualified email address of the Terraform service account to use for
project creation. E.g.
tf_sa_email = "org-terraform@[BOOTSTRAP_PROJECT].iam.gserviceaccount.com"
EOD
}

variable "tf_sa_token_lifetime_secs" {
  type        = number
  default     = 1200
  description = <<EOD
The expiration duration for the service account token, in seconds. This value
should be high enough to prevent token timeout issues during resource creation,
but short enough that the token is useless replayed later. Default value is 1200.
EOD
}

variable "project_id" {
  type        = string
  description = <<EOD
The existing project id that will be used for an F5 automation factory.
EOD
}

variable "subnets" {
  type        = list(string)
  description = <<EOD
A list of subnetwork self-links to use with the instance.
EOD
}

variable "metadata" {
  type        = map(string)
  default     = {}
  description = <<EOD
An optional map of metadata value that will be applied to the VMs.
EOD
}

variable "labels" {
  type        = map(string)
  default     = {}
  description = <<EOD
An optional map of label pairs to apply to the VMs.
EOD
}

variable "tags" {
  type        = list(string)
  default     = []
  description = <<EOD
An optional list of network tags to apply to the VMs.
EOD
}

variable "enable_os_login" {
  type        = bool
  default     = true
  description = <<EOD
Set to true to enable OS Login on the VMs. Default value is true.
NOTE: this value will override an 'enable-oslogin' key in `metadata` map.
EOD
}

variable "machine_type" {
  type        = string
  default     = "n1-standard-4"
  description = <<EOD
The machine type to use for webapps. Default is 'n1-standard-4'
EOD
}

variable "preemptible" {
  type        = bool
  default     = false
  description = <<EOD
Instructs the VM to be preemptible, default is false.
EOD
}

variable "disk_type" {
  type        = string
  default     = "pd-standard"
  description = <<EOD
The disk type to use for webapp VMs. Default is 'pd-standard'.
EOD
}

variable "disk_size_gb" {
  type        = number
  default     = 10
  description = <<EOD
The boot disk size, in Gb. Default is 10.
EOD
}

variable "source_image" {
  type        = string
  default     = "ubuntu-os-cloud/ubuntu-1804-lts"
  description = <<EOD
The source image to use for webapp VMs. Default is 'ubuntu-os-cloud/ubuntu-1804-lts'
to use latest Ubuntu 18.04 LTS image at apply time.
EOD
}

variable "auto_healing_initial_delay_sec" {
  type        = number
  default     = 60
  description = <<EOD
The initial delay in seconds before taking any auto healing actions. Default is
60.
EOD
}

variable "update_policy_type" {
  type        = string
  default     = "PROACTIVE"
  description = <<EOD
The update policy type to assign to the managed instance group; default is
'PROACTIVE' to support aggressive update.
EOD
}

variable "update_policy_minimal_action" {
  type        = string
  default     = "REPLACE"
  description = <<EOD
The minimal update policy action that is permitted as part of an update; default
is 'REPLACE' to support aggressive update.
EOD
}

variable "update_policy_max_surge_fixed" {
  type        = number
  default     = 3
  description = <<EOD
The maximum number of instances that can be created beyond the scaling count
before destroying old instances. Default value is 3.

NOTE: the value may be higher if required by the deployed region.
EOD
}

variable "update_policy_max_unavailable_fixed" {
  type        = number
  default     = 3
  description = <<EOD
The maximum number of instances that can become unavailable during an update
event. Default value is 3.

NOTE: the value may be higher if required by the deployed region.
EOD
}

variable "update_policy_min_ready_sec" {
  type        = number
  default     = 10
  description = <<EOD
The timeout duration after a update event before the health checking results are
considered.
EOD
}

variable "autoscaling_max_replicas" {
  type        = number
  default     = 5
  description = <<EOD
The maximum number of autoscaling instances in the Regional MIG. Default value is 5.
EOD
}

variable "autoscaling_min_replicas" {
  type        = number
  default     = 1
  description = <<EOD
The minimum number of autoscaling instances in the Regional MIG. Default value is 5.
EOD
}

variable "autoscaling_cooldown_period" {
  type        = number
  default     = 60
  description = <<EOD
The number of seconds to use for autoscaling cooldown, default to 60s.
EOD
}

variable "autoscaling_metric_name" {
  type        = string
  description = <<EOD
The fully-qualified metric to use for autoscaling.
E.g. custom.googleapis.com/my-metric
EOD
}

variable "autoscaling_metric_target" {
  type        = number
  default     = 3
  description = <<EOD
The amount of work to assign to a single instance; this will be compared to the
metric value and the number of instances will change to keep the work per instance
to below or equal to this value.
EOD
}

variable "autoscaling_metric_type" {
  type        = string
  default     = "GAUGE"
  description = <<EOD
The type of the target metric; must be one of 'GAUGE', 'DELTA_PER_SECOND', or
'DELTA_PER_MINUTE'. Default is 'GAUGE'.
EOD
}

variable "synthetic_metric_floor" {
  type        = number
  default     = 0
  description = <<EOD
The floor value that will be generated by synthetic metrics. Default is 0.
EOD
}

variable "synthetic_metric_ceiling" {
  type        = number
  default     = 5
  description = <<EOD
The ceiling value that will be generated by synthetic metrics. Default is 5.
EOD
}

variable "synthetic_metric_period" {
  type        = string
  default     = "20m"
  description = <<EOD
The period over which the synthetic metrics will perform a single wave cycle.
Default value is "20m". Must be a valid Go duration specifier.
EOD
}

variable "synthetic_metric_sample_period" {
  type        = string
  default     = "60s"
  description = <<EOD
The interval between reporting synthetic metrics. Default value is "60s". Must
be a valid Go duration specifier.
EOD
}

variable "synthetic_metric_shape" {
  type        = string
  default     = "triangle"
  description = <<EOD
The shape of the synthetic metric to generate; can be one of 'sawtooth', 'sine',
'square', or 'triangle' (default).
EOD
}
