data "aws_cloudwatch_log_group" "cloudtrail" {
  count = var.monitor_iam_activity_sns_topic_arn != null ? 1 : 0

  name = "aws-controltower/CloudTrailLogs"
}

data "aws_region" "current" {}
