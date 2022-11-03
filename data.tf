data "aws_cloudwatch_log_group" "cloudtrail" {
  count = var.monitor_iam_activity_sso ? 1 : 0
  name  = "aws-controltower/CloudTrailLogs"
}
