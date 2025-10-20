data "aws_region" "current" {}

locals {
  aws_config_aggregators = var.aws_config != null ? flatten([
    for account in var.aws_config.aggregator_account_ids : [
      for region in var.aws_config.aggregator_regions : {
        account_id = account
        region     = region
      }
    ]
  ]) : []

  regions_to_enable = var.enable_additional_eu_regions ? [
    "eu-central-2", # Zurich
    "eu-south-1",   # Milan
    "eu-south-2",   # Spain
  ] : []

  regions_to_baseline = distinct(concat(
    [data.aws_region.current.region],
    var.extra_regions_to_baseline
  ))
}
