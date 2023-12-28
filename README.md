# terraform-aws-mcaf-account-baseline

Terraform module to manage baseline configuration for AWS accounts.

## How to use

### Basic configuration

```hcl
module "account_baseline" {
  source = "github.com/schubergphilis/terraform-aws-mcaf-account-baseline?ref=VERSION"
}
```

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

## AWS Security Hub

This module enables the following standards by default:

- `AWS Foundational Security Best Practices v1.0.0`
- `CIS AWS Foundations Benchmark v1.4.0`
- `PCI DSS v3.2.1`

You are able to control the enabled standards via `var.aws_security_hub_standards_arns`.

## Monitoring IAM Activity

This module offers the capability of monitoring IAM activity of both the Root user and AWS SSO roles. To enable this feature, you have to provide the ARN of the SNS Topic that should receive events in case any activity is detected.

The topic ARN can be set using `var.monitor_iam_activity_sns_topic_arn`.

These are two type of events that will be monitored:

- Any activity made by the root user of the account.
- Any manual changes made by AWS SSO roles (read-only operations and console logins are not taken into account).

In case you would like to NOT monitor AWS SSO role activity, you can set `var.monitor_iam_activity_sso` to `false`.

Example:

```hcl
monitor_iam_activity_sns_topic_arn = "arn:aws:sns:eu-west-1:123456789012:LandingZone-IAMActivity"
monitor_iam_activity_sso           = false
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.0.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_service_quota_manager_role"></a> [service\_quota\_manager\_role](#module\_service\_quota\_manager\_role) | github.com/schubergphilis/terraform-aws-mcaf-role | v0.3.3 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_metric_filter.iam_activity](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_metric_filter) | resource |
| [aws_cloudwatch_metric_alarm.iam_activity](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_config_aggregate_authorization.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/config_aggregate_authorization) | resource |
| [aws_ebs_default_kms_key.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ebs_default_kms_key) | resource |
| [aws_ebs_encryption_by_default.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ebs_encryption_by_default) | resource |
| [aws_iam_account_password_policy.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_account_password_policy) | resource |
| [aws_securityhub_standards_subscription.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/securityhub_standards_subscription) | resource |
| [aws_cloudwatch_log_group.cloudtrail](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/cloudwatch_log_group) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_password_policy"></a> [account\_password\_policy](#input\_account\_password\_policy) | AWS account password policy parameters | <pre>object({<br>    allow_users_to_change        = bool<br>    max_age                      = number<br>    minimum_length               = number<br>    require_lowercase_characters = bool<br>    require_numbers              = bool<br>    require_symbols              = bool<br>    require_uppercase_characters = bool<br>    reuse_prevention_history     = number<br>  })</pre> | <pre>{<br>  "allow_users_to_change": true,<br>  "max_age": 90,<br>  "minimum_length": 14,<br>  "require_lowercase_characters": true,<br>  "require_numbers": true,<br>  "require_symbols": true,<br>  "require_uppercase_characters": true,<br>  "reuse_prevention_history": 24<br>}</pre> | no |
| <a name="input_aws_config"></a> [aws\_config](#input\_aws\_config) | AWS Config settings | <pre>object({<br>    aggregator_account_ids = list(string)<br>    aggregator_regions     = list(string)<br>  })</pre> | `null` | no |
| <a name="input_aws_ebs_encryption_by_default"></a> [aws\_ebs\_encryption\_by\_default](#input\_aws\_ebs\_encryption\_by\_default) | Set to true to enable AWS Elastic Block Store encryption by default | `bool` | `true` | no |
| <a name="input_aws_ebs_encryption_custom_key"></a> [aws\_ebs\_encryption\_custom\_key](#input\_aws\_ebs\_encryption\_custom\_key) | Set to true and specify the `aws_kms_key_arn` to use in place of the AWS-managed default CMK | `bool` | `false` | no |
| <a name="input_aws_kms_key_arn"></a> [aws\_kms\_key\_arn](#input\_aws\_kms\_key\_arn) | The ARN of the AWS Key Management Service (AWS KMS) customer master key (CMK) to use to encrypt the EBS volumes | `string` | `null` | no |
| <a name="input_aws_security_hub_standards_arns"></a> [aws\_security\_hub\_standards\_arns](#input\_aws\_security\_hub\_standards\_arns) | A list of the ARNs of the standards you want to enable in AWS Security Hub. If you do not provide a list the default standards are enabled | `list(string)` | `null` | no |
| <a name="input_monitor_iam_activity_sns_topic_arn"></a> [monitor\_iam\_activity\_sns\_topic\_arn](#input\_monitor\_iam\_activity\_sns\_topic\_arn) | SNS Topic that should receive captured IAM activity events | `string` | `null` | no |
| <a name="input_monitor_iam_activity_sso"></a> [monitor\_iam\_activity\_sso](#input\_monitor\_iam\_activity\_sso) | Whether IAM activity from SSO roles should be monitored | `bool` | `true` | no |
| <a name="input_service_quotas_manager_role"></a> [service\_quotas\_manager\_role](#input\_service\_quotas\_manager\_role) | Create the role needed to integrate the terraform-aws-mcaf-service-quotas-manager module | <pre>object({<br>    assuming_principal_identifier = string<br>    path                          = optional(string, "/")<br>    permissions_boundary          = optional(string, null)<br>  })</pre> | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of tags | `map(string)` | `{}` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
