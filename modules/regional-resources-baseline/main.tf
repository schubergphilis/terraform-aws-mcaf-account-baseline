# Security Hub control: EC2.7
resource "aws_ebs_encryption_by_default" "default" {
  region = var.region

  enabled = var.aws_ebs_encryption_by_default
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
  kms_key_id        = var.aws_kms_key_arn
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
