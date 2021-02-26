data "aws_cloudwatch_log_group" "cloudtrail" {
  name = "aws-controltower/CloudTrailLogs"
}
