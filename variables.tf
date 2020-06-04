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
  default     = "cos-cloud/cos-stable"
  description = <<EOD
The source image to use for webapp VMs. Default is 'cos-cloud/cos-stable' to use
latest Container-Optimized OS image at apply time.
EOD
}

variable "target_size" {
  type        = number
  default     = 3
  description = <<EOD
The number of instances in the Regional MIG. Default value is 3.
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
