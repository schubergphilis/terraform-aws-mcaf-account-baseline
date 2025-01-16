locals {
  aws_config_aggregators = var.aws_config != null ? flatten([
    for account in var.aws_config.aggregator_account_ids : [
      for region in var.aws_config.aggregator_regions : {
        account_id = account
        region     = region
      }
    ]
  ]) : []
}
