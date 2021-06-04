variable "account_password_policy" {
  type = object({
    allow_users_to_change        = bool
    max_age                      = number
    minimum_length               = number
    require_lowercase_characters = bool
    require_numbers              = bool
    require_symbols              = bool
    require_uppercase_characters = bool
    reuse_prevention_history     = number
  })
  default = {
    allow_users_to_change        = true
    max_age                      = 90
    minimum_length               = 14
    require_lowercase_characters = true
    require_numbers              = true
    require_symbols              = true
    require_uppercase_characters = true
    reuse_prevention_history     = 24
  }
  description = "AWS account password policy parameters"
}

variable "aws_config" {
  type = object({
    aggregator_account_ids = list(string)
    aggregator_regions     = list(string)
  })
  default     = null
  description = "AWS Config settings"
}

variable "aws_ebs_encryption_by_default" {
  type        = bool
  default     = true
  description = "Set to true to enable AWS Elastic Block Store encryption by default"
}

variable "aws_ebs_encryption_custom_key" {
  type        = bool
  default     = false
  description = "Set to true and specify the `aws_kms_key_arn` to use in place of the AWS-managed default CMK"
}

variable "aws_kms_key_arn" {
  type        = string
  default     = null
  description = "The ARN of the AWS Key Management Service (AWS KMS) customer master key (CMK) to use to encrypt the EBS volumes"
}

variable "monitor_iam_activity_sns_topic_arn" {
  type        = string
  default     = null
  description = "SNS Topic that should receive captured IAM activity events"
}

variable "monitor_iam_activity_sso" {
  type        = bool
  default     = true
  description = "Whether IAM activity from SSO roles should be monitored"
}

variable "tags" {
  type        = map(string)
  description = "Map of tags"
}
