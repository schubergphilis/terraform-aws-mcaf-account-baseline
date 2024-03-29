resource "aws_config_aggregate_authorization" "default" {
  for_each = { for aggregator in local.aws_config_aggregators : "${aggregator.account_id}-${aggregator.region}" => aggregator }

  account_id = each.value.account_id
  region     = each.value.region
  tags       = var.tags
}

resource "aws_ebs_encryption_by_default" "default" {
  enabled = var.aws_ebs_encryption_by_default
}

resource "aws_ebs_default_kms_key" "default" {
  count = var.aws_ebs_encryption_custom_key == true ? 1 : 0

  key_arn = var.aws_kms_key_arn
}

resource "aws_iam_account_password_policy" "default" {
  count = var.account_password_policy != null ? 1 : 0

  allow_users_to_change_password = var.account_password_policy.allow_users_to_change
  max_password_age               = var.account_password_policy.max_age
  minimum_password_length        = var.account_password_policy.minimum_length
  password_reuse_prevention      = var.account_password_policy.reuse_prevention_history
  require_lowercase_characters   = var.account_password_policy.require_lowercase_characters
  require_numbers                = var.account_password_policy.require_numbers
  require_symbols                = var.account_password_policy.require_symbols
  require_uppercase_characters   = var.account_password_policy.require_uppercase_characters
}

resource "aws_securityhub_standards_subscription" "default" {
  for_each = toset(local.security_hub_standards_arns)

  standards_arn = each.value
}

module "service_quota_manager_role" {
  count  = var.service_quotas_manager_role != null ? 1 : 0
  source = "github.com/schubergphilis/terraform-aws-mcaf-role?ref=v0.3.3"

  name                  = "ServiceQuotasManager"
  create_policy         = true
  path                  = var.service_quotas_manager_role.path
  permissions_boundary  = var.service_quotas_manager_role.permissions_boundary
  policy_arns           = ["arn:aws:iam::aws:policy/ServiceQuotasReadOnlyAccess"]
  postfix               = true
  principal_identifiers = [var.service_quotas_manager_role.assuming_principal_identifier]
  principal_type        = "AWS"
  tags                  = var.tags

  role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "AllowConfigReadAccess",
          "Effect" : "Allow",
          "Action" : "config:SelectResourceConfig",
          "Resource" : "*"
        },
        {
          "Sid" : "AllowSupportAccess",
          "Effect" : "Allow",
          "Action" : [
            "support:DescribeSeverityLevels",
            "support:AddCommunicationToCase"
          ],
          "Resource" : "*"
        },
        {
          "Sid" : "AllowCeAccessForServiceAutoDiscovery",
          "Effect" : "Allow",
          "Action" : [
            "ce:GetCostAndUsage"
          ],
          "Resource" : "*"
        },
        {
          "Sid" : "AllowServiceQuotaIncreaseRequestAccess",
          "Effect" : "Allow",
          "Action" : [
            "servicequotas:RequestServiceQuotaIncrease"
          ],
          "Resource" : "*"
        }
      ]
    }
  )
}
