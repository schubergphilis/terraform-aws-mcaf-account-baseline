variable "region" {
  type = string
}

variable "aws_ebs_encryption_by_default" {
  type = bool
}

variable "aws_ebs_encryption_custom_key" {
  type    = bool
  default = false
}

variable "aws_ebs_snapshot_block_public_access_state" {
  type = string
}

variable "aws_kms_key_arns" {
  type    = map(string)
  default = {}
}

variable "aws_ssm_automation_logging_enabled" {
  type = bool
}

variable "aws_ssm_automation_log_group_name" {
  type = string
}

variable "aws_ssm_documents_public_sharing_permission" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}
