# terraform-aws-mcaf-account-baseline

Terraform module to manage baseline configuration for AWS accounts.

## How to use

### Basic configuration

```hcl
module "account_baseline" {
  source = "github.com/schubergphilis/terraform-aws-mcaf-account-baseline?ref=VERSION"
}
```

### EU Region Enablement

By default, this module enables all non-default EU regions (`eu-central-2`, `eu-south-1`, `eu-south-2`). To actually use these regions, they must also be included in the allowed regions SCP of the
[mcaf-landing-zone module](https://github.com/schubergphilis/terraform-aws-mcaf-landing-zone).

This module ensures that you can use all EU regions out of the box. If you intend to allow a region across your entire organization, the recommended approach is to also configure it as a governed region via AWS Control Tower. This ensures consistent enforcement of security, compliance, and operational guardrails.

## AWS Config Rules

If you would like to authorise other accounts to aggregate AWS Config data, account IDs and regions can be passed to `var.aws_config` using the attributes `aggregator_account_ids` and `aggregator_regions` respectively.

> **Note**
> Control Tower already authorizes the `audit` account to aggregate Config data from all other accounts in the organization, so there is no need to specify the `audit` account ID in the `aggregator_account_ids` list.

Example:

```hcl
aws_config = {
  aggregator_account_ids = ["123456789012"]
  aggregator_regions     = ["eu-west-1"]
}
```

## MCAF Service Quotas Manager integration

This module can deploy the IAM role required by the [MCAF Service Quotas Manager](https://github.com/schubergphilis/terraform-aws-mcaf-service-quotas-manager) module. The `assuming_principal_identifier` should be the `ServiceQuotasManagerExecutionRole`. This is by default `arn:aws:iam::<account_id>:role/ServiceQuotasManagerExecutionRole-<region_name>`.

> [!NOTE]  
> The Service Quotas Manager module should be deployed first before deploying this integration. Only existing IAM roles can be referenced as principals.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.7.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6.7.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 6.7.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_regional_resources_baseline"></a> [regional\_resources\_baseline](#module\_regional\_resources\_baseline) | ./modules/regional-resources-baseline | n/a |
| <a name="module_service_quota_manager_role"></a> [service\_quota\_manager\_role](#module\_service\_quota\_manager\_role) | schubergphilis/mcaf-role/aws | ~> 0.4.0 |

## Resources

| Name | Type |
|------|------|
| [aws_account_region.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/account_region) | resource |
| [aws_config_aggregate_authorization.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/config_aggregate_authorization) | resource |
| [aws_ebs_default_kms_key.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ebs_default_kms_key) | resource |
| [aws_ec2_image_block_public_access.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_image_block_public_access) | resource |
| [aws_iam_account_password_policy.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_account_password_policy) | resource |
| [aws_s3_account_public_access_block.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_account_public_access_block) | resource |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_password_policy"></a> [account\_password\_policy](#input\_account\_password\_policy) | AWS account password policy parameters | <pre>object({<br/>    allow_users_to_change        = bool<br/>    max_age                      = number<br/>    minimum_length               = number<br/>    require_lowercase_characters = bool<br/>    require_numbers              = bool<br/>    require_symbols              = bool<br/>    require_uppercase_characters = bool<br/>    reuse_prevention_history     = number<br/>  })</pre> | <pre>{<br/>  "allow_users_to_change": true,<br/>  "max_age": 90,<br/>  "minimum_length": 14,<br/>  "require_lowercase_characters": true,<br/>  "require_numbers": true,<br/>  "require_symbols": true,<br/>  "require_uppercase_characters": true,<br/>  "reuse_prevention_history": 24<br/>}</pre> | no |
| <a name="input_aws_config"></a> [aws\_config](#input\_aws\_config) | AWS Config settings | <pre>object({<br/>    aggregator_account_ids = list(string)<br/>    aggregator_regions     = list(string)<br/>  })</pre> | `null` | no |
| <a name="input_aws_ebs_encryption_by_default"></a> [aws\_ebs\_encryption\_by\_default](#input\_aws\_ebs\_encryption\_by\_default) | Set to true to enable AWS Elastic Block Store encryption by default | `bool` | `true` | no |
| <a name="input_aws_ebs_encryption_custom_key"></a> [aws\_ebs\_encryption\_custom\_key](#input\_aws\_ebs\_encryption\_custom\_key) | Set to true and specify the `aws_kms_key_arn` to use in place of the AWS-managed default CMK | `bool` | `false` | no |
| <a name="input_aws_ebs_snapshot_block_public_access"></a> [aws\_ebs\_snapshot\_block\_public\_access](#input\_aws\_ebs\_snapshot\_block\_public\_access) | Configure regionally the EBS snapshot public sharing policy, alternatives: `block-all-sharing` and `unblocked` | `string` | `"block-new-sharing"` | no |
| <a name="input_aws_ec2_image_block_public_access"></a> [aws\_ec2\_image\_block\_public\_access](#input\_aws\_ec2\_image\_block\_public\_access) | Set to true to regionally block new AMIs from being publicly shared | `bool` | `true` | no |
| <a name="input_aws_kms_key_arn"></a> [aws\_kms\_key\_arn](#input\_aws\_kms\_key\_arn) | The ARN of the AWS Key Management Service (AWS KMS) customer master key (CMK) to use to encrypt the EBS volumes | `string` | `null` | no |
| <a name="input_aws_s3_public_access_block_config"></a> [aws\_s3\_public\_access\_block\_config](#input\_aws\_s3\_public\_access\_block\_config) | S3 bucket-level Public Access Block config | <pre>object({<br/>    enabled                 = optional(bool, true)<br/>    block_public_acls       = optional(bool, true)<br/>    block_public_policy     = optional(bool, true)<br/>    ignore_public_acls      = optional(bool, true)<br/>    restrict_public_buckets = optional(bool, true)<br/>  })</pre> | `{}` | no |
| <a name="input_aws_ssm_documents_public_sharing_permission"></a> [aws\_ssm\_documents\_public\_sharing\_permission](#input\_aws\_ssm\_documents\_public\_sharing\_permission) | Configure the SSM documents public sharing policy, alternatives: `Enable` | `string` | `"Disable"` | no |
| <a name="input_enable_additional_eu_regions"></a> [enable\_additional\_eu\_regions](#input\_enable\_additional\_eu\_regions) | Enable all additional EU AWS Regions beyond the default ones | `bool` | `true` | no |
| <a name="input_extra_regions_to_baseline"></a> [extra\_regions\_to\_baseline](#input\_extra\_regions\_to\_baseline) | List of additional regions to apply the baseline, defaults to us-east-1 | `list(string)` | <pre>[<br/>  "us-east-1"<br/>]</pre> | no |
| <a name="input_service_quotas_manager_role"></a> [service\_quotas\_manager\_role](#input\_service\_quotas\_manager\_role) | Create the role needed to integrate the terraform-aws-mcaf-service-quotas-manager module | <pre>object({<br/>    assuming_principal_identifier = string<br/>    path                          = optional(string, "/")<br/>    permissions_boundary          = optional(string, null)<br/>  })</pre> | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of tags | `map(string)` | `{}` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
