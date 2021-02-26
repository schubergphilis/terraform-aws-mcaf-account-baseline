locals {
  aws_config_aggregators = var.aws_config != null ? flatten([
    for account in var.aws_config.aggregator_account_ids : [
      for region in var.aws_config.aggregator_regions : {
        account_id = account
        region     = region
      }
    ]
  ]) : []

  iam_activity = merge(
    {
      Root = "{ $.userIdentity.type = \"Root\" }"
    },
    var.monitor_iam_activity_sso == true ? {
      SSO = "{ $.readOnly IS FALSE  && $.userIdentity.sessionContext.sessionIssuer.userName = \"AWSReservedSSO_*\" && $.eventName != \"ConsoleLogin\" }"
    } : {}
  )
}
