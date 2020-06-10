# Multi-nic

![pre-commit](https://github.com/memes/f5-google-automation-factory/workflows/pre-commit/badge.svg)

Example showing scaling/MIG with multi-nic instances.

<!-- markdownlint-disable no-inline-html -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 0.12 |
| google | ~> 3.24 |
| google | ~> 3.24 |

## Providers

| Name | Version |
|------|---------|
| google | ~> 3.24 ~> 3.24 |
| google.executor | ~> 3.24 ~> 3.24 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| auto\_healing\_initial\_delay\_sec | The initial delay in seconds before taking any auto healing actions. Default is<br>60. | `number` | `60` | no |
| autoscaling\_cooldown\_period | The number of seconds to use for autoscaling cooldown, default to 60s. | `number` | `60` | no |
| autoscaling\_max\_replicas | The maximum number of autoscaling instances in the Regional MIG. Default value is 5. | `number` | `5` | no |
| autoscaling\_metric\_name | The fully-qualified metric to use for autoscaling.<br>E.g. custom.googleapis.com/my-metric | `string` | n/a | yes |
| autoscaling\_metric\_target | The amount of work to assign to a single instance; this will be compared to the<br>metric value and the number of instances will change to keep the work per instance<br>to below or equal to this value. | `number` | `3` | no |
| autoscaling\_metric\_type | The type of the target metric; must be one of 'GAUGE', 'DELTA\_PER\_SECOND', or<br>'DELTA\_PER\_MINUTE'. Default is 'GAUGE'. | `string` | `"GAUGE"` | no |
| autoscaling\_min\_replicas | The minimum number of autoscaling instances in the Regional MIG. Default value is 5. | `number` | `1` | no |
| disk\_size\_gb | The boot disk size, in Gb. Default is 10. | `number` | `10` | no |
| disk\_type | The disk type to use for webapp VMs. Default is 'pd-standard'. | `string` | `"pd-standard"` | no |
| enable\_os\_login | Set to true to enable OS Login on the VMs. Default value is true.<br>NOTE: this value will override an 'enable-oslogin' key in `metadata` map. | `bool` | `true` | no |
| labels | An optional map of label pairs to apply to the VMs. | `map(string)` | `{}` | no |
| machine\_type | The machine type to use for webapps. Default is 'n1-standard-4' | `string` | `"n1-standard-4"` | no |
| metadata | An optional map of metadata value that will be applied to the VMs. | `map(string)` | `{}` | no |
| preemptible | Instructs the VM to be preemptible, default is false. | `bool` | `false` | no |
| project\_id | The existing project id that will be used for an F5 automation factory. | `string` | n/a | yes |
| source\_image | The source image to use for webapp VMs. Default is 'cos-cloud/cos-stable' to use<br>latest Container-Optimized OS image at apply time. | `string` | `"cos-cloud/cos-stable"` | no |
| subnets | A list of subnetwork self-links to use with the instance. | `list(string)` | n/a | yes |
| synthetic\_metric\_ceiling | The ceiling value that will be generated by synthetic metrics. Default is 5. | `number` | `5` | no |
| synthetic\_metric\_floor | The floor value that will be generated by synthetic metrics. Default is 0. | `number` | `0` | no |
| synthetic\_metric\_period | The period over which the synthetic metrics will perform a single wave cycle.<br>Default value is "20m". Must be a valid Go duration specifier. | `string` | `"20m"` | no |
| synthetic\_metric\_sample\_period | The interval between reporting synthetic metrics. Default value is "60s". Must<br>be a valid Go duration specifier. | `string` | `"60s"` | no |
| synthetic\_metric\_shape | The shape of the synthetic metric to generate; can be one of 'sawtooth', 'sine',<br>'square', or 'triangle' (default). | `string` | `"triangle"` | no |
| tags | An optional list of network tags to apply to the VMs. | `list(string)` | `[]` | no |
| tf\_sa\_email | The fully-qualified email address of the Terraform service account to use for<br>project creation. E.g.<br>tf\_sa\_email = "org-terraform@[BOOTSTRAP\_PROJECT].iam.gserviceaccount.com" | `string` | n/a | yes |
| tf\_sa\_token\_lifetime\_secs | The expiration duration for the service account token, in seconds. This value<br>should be high enough to prevent token timeout issues during resource creation,<br>but short enough that the token is useless replayed later. Default value is 1200. | `number` | `1200` | no |
| update\_policy\_max\_surge\_fixed | The maximum number of instances that can be created beyond the scaling count<br>before destroying old instances. Default value is 3.<br><br>NOTE: the value may be higher if required by the deployed region. | `number` | `3` | no |
| update\_policy\_max\_unavailable\_fixed | The maximum number of instances that can become unavailable during an update<br>event. Default value is 3.<br><br>NOTE: the value may be higher if required by the deployed region. | `number` | `3` | no |
| update\_policy\_min\_ready\_sec | The timeout duration after a update event before the health checking results are<br>considered. | `number` | `10` | no |
| update\_policy\_minimal\_action | The minimal update policy action that is permitted as part of an update; default<br>is 'REPLACE' to support aggressive update. | `string` | `"REPLACE"` | no |
| update\_policy\_type | The update policy type to assign to the managed instance group; default is<br>'PROACTIVE' to support aggressive update. | `string` | `"PROACTIVE"` | no |

## Outputs

No output.

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
<!-- markdownlint-enable no-inline-html -->
