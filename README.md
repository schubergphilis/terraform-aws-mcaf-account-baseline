# terraform-aws-mcaf-account-baseline
Terraform module to setup a baseline configuration for AWS accounts.

## How to use

### Basic configuration
```hcl
module "account_baseline" {
  source = "github.com/schubergphilis/terraform-aws-mcaf-account-baseline?ref=VERSION"
  tags   = var.tags
}
```

## AWS Config Rules

If you would like to authorize other accounts to aggregate AWS Config data, the account IDs and regions can be passed via the variable `aws_config` using the attributes `aggregator_account_ids` and `aggregator_regions` respectively.

NOTE: Control Tower already authorizes the `audit` account to aggregate Config data from all other accounts in the organization, so there is no need to specify the `audit` account ID in the `aggregator_account_ids` list.

Example:

```hcl
aws_config = {
  aggregator_account_ids = ["123456789012"]
  aggregator_regions     = ["eu-west-1"]
}
```

## Monitoring IAM Activity

This module offers the capability of monitoring IAM activity of both the Root user and AWS SSO roles. To enable this feature, you have to provide the ARN of the SNS Topic that should receive events in case any activity is detected.

The topic ARN can be set using the variable `monitor_iam_activity_sns_topic_arn`.

These are the type of events that will be monitored:

- Any activity made by the root user of the account.
- Any manual changes made by AWS SSO roles (read-only operations and console logins are not taken into account).

In case you would like to NOT monitor AWS SSO roles, you can set `monitor_iam_activity_sso` to `false`.

Example:

```hcl
monitor_iam_activity_sns_topic_arn = "arn:aws:sns:eu-west-1:123456789012:LandingZone-IAMActivity"
monitor_iam_activity_sso           = false
```

<!--- BEGIN_TF_DOCS --->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13 |

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| tags | Map of tags | `map(string)` | n/a | yes |
| account\_password\_policy | AWS account password policy parameters | <pre>object({<br>    allow_users_to_change        = bool<br>    max_age                      = number<br>    minimum_length               = number<br>    require_lowercase_characters = bool<br>    require_numbers              = bool<br>    require_symbols              = bool<br>    require_uppercase_characters = bool<br>    reuse_prevention_history     = number<br>  })</pre> | <pre>{<br>  "allow_users_to_change": true,<br>  "max_age": 90,<br>  "minimum_length": 14,<br>  "require_lowercase_characters": true,<br>  "require_numbers": true,<br>  "require_symbols": true,<br>  "require_uppercase_characters": true,<br>  "reuse_prevention_history": 24<br>}</pre> | no |
| aws\_config | AWS Config settings | <pre>object({<br>    aggregator_account_ids = list(string)<br>    aggregator_regions     = list(string)<br>  })</pre> | `null` | no |
| aws\_ebs\_encryption\_by\_default | Set to true to enable AWS Elastic Block Store encryption by default | `bool` | `true` | no |
| aws\_ebs\_encryption\_custom\_key | Set to true and specify the `aws_kms_key_arn` to use in place of the AWS-managed default CMK | `bool` | `false` | no |
| aws\_kms\_key\_arn | The ARN of the AWS Key Management Service (AWS KMS) customer master key (CMK) to use to encrypt the EBS volumes | `string` | `null` | no |
| monitor\_iam\_activity\_sns\_topic\_arn | SNS Topic that should receive captured IAM activity events | `string` | `null` | no |
| monitor\_iam\_activity\_sso | Whether IAM activity from SSO roles should be monitored | `bool` | `true` | no |

## Outputs

No output.

<!--- END_TF_DOCS --->
