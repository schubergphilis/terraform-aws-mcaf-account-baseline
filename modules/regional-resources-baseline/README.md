<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.ssm_automation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_ebs_encryption_by_default.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ebs_encryption_by_default) | resource |
| [aws_ebs_snapshot_block_public_access.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ebs_snapshot_block_public_access) | resource |
| [aws_ssm_service_setting.automation_log_destination](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_service_setting) | resource |
| [aws_ssm_service_setting.automation_log_group_name](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_service_setting) | resource |
| [aws_ssm_service_setting.documents_public_sharing_permission](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_service_setting) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_ebs_encryption_by_default"></a> [aws\_ebs\_encryption\_by\_default](#input\_aws\_ebs\_encryption\_by\_default) | n/a | `bool` | n/a | yes |
| <a name="input_aws_ebs_snapshot_block_public_access_state"></a> [aws\_ebs\_snapshot\_block\_public\_access\_state](#input\_aws\_ebs\_snapshot\_block\_public\_access\_state) | n/a | `string` | n/a | yes |
| <a name="input_aws_ssm_automation_log_group_name"></a> [aws\_ssm\_automation\_log\_group\_name](#input\_aws\_ssm\_automation\_log\_group\_name) | n/a | `string` | n/a | yes |
| <a name="input_aws_ssm_automation_logging_enabled"></a> [aws\_ssm\_automation\_logging\_enabled](#input\_aws\_ssm\_automation\_logging\_enabled) | n/a | `bool` | n/a | yes |
| <a name="input_aws_ssm_documents_public_sharing_permission"></a> [aws\_ssm\_documents\_public\_sharing\_permission](#input\_aws\_ssm\_documents\_public\_sharing\_permission) | n/a | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | n/a | yes |
| <a name="input_aws_kms_key_arn"></a> [aws\_kms\_key\_arn](#input\_aws\_kms\_key\_arn) | n/a | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(string)` | `{}` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->