resource "aws_account_region" "default" {
  for_each = toset(local.regions_to_enable)

  region_name = each.value
  enabled     = true
}

resource "aws_config_aggregate_authorization" "default" {
  for_each = { for aggregator in local.aws_config_aggregators : "${aggregator.account_id}-${aggregator.region}" => aggregator }

  account_id            = each.value.account_id
  authorized_aws_region = each.value.region
  tags                  = var.tags
}

resource "aws_ebs_default_kms_key" "default" {
  count = var.aws_ebs_encryption_custom_key == true ? 1 : 0

  key_arn = var.aws_kms_key_arn
}

# Security Hub control: IAM.7, IAM.10, IAM.11, IAM.12, IAM.13, IAM.14, IAM.15, IAM.16, IAM.17
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

# This is set regionally, but enforced account-wide, see:
# https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/manage-block-public-access-for-amis.html#enable-block-public-access-for-amis
# Security Hub control: EC2.1
resource "aws_ec2_image_block_public_access" "default" {
  state = var.aws_ec2_image_block_public_access_state
}

# Security Hub control: S3.1
resource "aws_s3_account_public_access_block" "default" {
  count = var.aws_s3_public_access_block_config.enabled ? 1 : 0

  block_public_acls       = var.aws_s3_public_access_block_config.block_public_acls
  block_public_policy     = var.aws_s3_public_access_block_config.block_public_policy
  ignore_public_acls      = var.aws_s3_public_access_block_config.ignore_public_acls
  restrict_public_buckets = var.aws_s3_public_access_block_config.restrict_public_buckets
}

module "regional_resources_baseline" {
  for_each = toset(local.regions_to_baseline)

  source = "./modules/regional-resources-baseline"

  region                                      = each.value
  aws_ebs_encryption_by_default               = var.aws_ebs_encryption_by_default
  aws_ebs_snapshot_block_public_access_state  = var.aws_ebs_snapshot_block_public_access_state
  aws_kms_key_arn                             = var.aws_kms_key_arn
  aws_ssm_automation_log_group_name           = var.aws_ssm_automation_log_group_name
  aws_ssm_automation_logging_enabled          = var.aws_ssm_automation_logging_enabled
  aws_ssm_documents_public_sharing_permission = var.aws_ssm_documents_public_sharing_permission
  tags                                        = var.tags
}

module "service_quota_manager_role" {
  count = var.service_quotas_manager_role != null ? 1 : 0

  source  = "schubergphilis/mcaf-role/aws"
  version = "~> 0.5.3"

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
