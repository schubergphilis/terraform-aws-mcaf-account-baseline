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
<!--- END_TF_DOCS --->
