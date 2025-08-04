resource "aws_ssm_service_setting" "documents_public_sharing_permission" {
  for_each = var.regions_to_baseline

  region = each.key

  setting_id    = "/ssm/documents/console/public-sharing-permission"
  setting_value = var.aws_ssm_documents_public_sharing_permission
}
