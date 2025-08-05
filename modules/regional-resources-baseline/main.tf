resource "aws_ssm_service_setting" "documents_public_sharing_permission" {
  region = var.region

  setting_id    = "/ssm/documents/console/public-sharing-permission"
  setting_value = var.aws_ssm_documents_public_sharing_permission
}
