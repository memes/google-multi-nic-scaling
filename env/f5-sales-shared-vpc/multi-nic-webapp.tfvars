# Use this file to set Terraform variables shared by all solution modules
project_id  = "f5-gcs-4261-sales-shrdvpc-host"
tf_sa_email = "terraform@f5-gcs-4261-sales-shrdvpc-host.iam.gserviceaccount.com"
subnets = [
  "https://www.googleapis.com/compute/v1/projects/f5-gcs-4261-sales-shrdvpc-host/regions/us-west1/subnetworks/na-west-ext",
  "https://www.googleapis.com/compute/v1/projects/f5-gcs-4261-sales-shrdvpc-host/regions/us-west1/subnetworks/na-west-int",
  "https://www.googleapis.com/compute/v1/projects/f5-gcs-4261-sales-shrdvpc-host/regions/us-west1/subnetworks/na-west-mgmt",
]
autoscaling_min_replicas = 1
autoscaling_max_replicas = 5
autoscaling_metric_name  = "custom.googleapis.com/gce_metric_1_5"
