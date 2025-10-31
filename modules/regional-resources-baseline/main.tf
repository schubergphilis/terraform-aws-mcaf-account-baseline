# Security Hub control: EC2.7
resource "aws_ebs_encryption_by_default" "default" {
  region = var.region

  enabled = var.aws_ebs_encryption_by_default
}

# Default KMS key to use for EBS encryption
resource "aws_ebs_default_kms_key" "default" {
  count = var.aws_ebs_encryption_custom_key && try(var.aws_kms_key_arns[var.region], null) != null ? 1 : 0

  region  = var.region
  key_arn = var.aws_kms_key_arns[var.region]
}

# Security Hub control: EC2.1
resource "aws_ebs_snapshot_block_public_access" "default" {
  region = var.region

  state = var.aws_ebs_snapshot_block_public_access_state
}

# Security Hub control: SSM.6
resource "aws_ssm_service_setting" "automation_log_destination" {
  count = var.aws_ssm_automation_logging_enabled ? 1 : 0

  region        = var.region
  setting_id    = "/ssm/automation/customer-script-log-destination"
  setting_value = "CloudWatch"
}

resource "aws_cloudwatch_log_group" "ssm_automation" {
  count = var.aws_ssm_automation_logging_enabled ? 1 : 0

  region            = var.region
  name              = var.aws_ssm_automation_log_group_name
  retention_in_days = 365
  kms_key_id        = try(var.aws_kms_key_arns[var.region], null) # attach key if provided for this region
  tags              = var.tags
}

resource "aws_ssm_service_setting" "automation_log_group_name" {
  count = var.aws_ssm_automation_logging_enabled ? 1 : 0

  region        = var.region
  setting_id    = "/ssm/automation/customer-script-log-group-name"
  setting_value = aws_cloudwatch_log_group.ssm_automation[0].name
}

# Security Hub control: SSM.7
resource "aws_ssm_service_setting" "documents_public_sharing_permission" {
  region = var.region

  setting_id    = "/ssm/documents/console/public-sharing-permission"
  setting_value = var.aws_ssm_documents_public_sharing_permission
}
