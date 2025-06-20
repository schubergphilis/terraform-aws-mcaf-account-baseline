# Upgrading Notes

This document captures required refactoring on your part when upgrading to a module version that contains breaking changes.

## Upgrading to v4.0.0

### Key Changes v4.0.0

This version introduces automatic enablement of all non-default EU regions. Previously, users had to opt in to these regions via Control Tower also in use cases where full Control Tower governance was not required. To avoid throttling on large orgs, only non-default EU regions (eu-central-2, eu-south-1, eu-south-2) are enabled by default.

### Variables v4.0.0

The following variables have been added:

- `enable_additional_eu_regions` (`bool`, default: `true`). Toggle automatic opt-in of non-default EU regions. Set to `false` to disable this behavior.

## Upgrading to v3.0.0

### Key Changes v3.0.0

This version sets secure defaults for regional public sharing of EC2 artifacts: block sharing newly created AMIs and EBS snapshots.

### Variables v3.0.0

The following variables have been added:

- `aws_ec2_image_block_public_access`. Set to true to regionally block new AMIs from being publicly shared (false will set to `unblocked`).
- `aws_ebs_snapshot_block_public_access`. Configure regionally the EBS snapshot public sharing policy (`block-new-sharing`), alternatives: `block-all-sharing` and `unblocked`.

### How to upgrade v3.0.0

If the secure default (blocking new EC2 artifacts from sharing) is what you desire, then no action is required.
If you want to deploy backwards compatibly, then:

- Set `aws_ec2_image_block_public_access` to `false`.
- Set `aws_ebs_snapshot_block_public_access` to `unblocked`.

## Upgrading to v2.0.0

### Key Changes v2.0.0

#### Transition to Centralized Security Hub Configuration

This version relies on the centralized security hub configuration as added in [terraform-aws-mcaf-landing-zone version v5.0.0](https://github.com/schubergphilis/terraform-aws-mcaf-landing-zone/releases/tag/v5.0.0)

Using centralized security hub it's no longer possible to modify the AWS SecurityHub standards in the account itself, therefore this functionality has been removed from this module.

### Variables v2.0.0

The following variables have been removed:

- `aws_security_hub_standards_arns`. This variable is not configurable anymore using security hub central configuration.

### How to upgrade v2.0.0

1. Upgrade your landing zone deployment to v5.0.0 or higher FIRST, before updating your account-baseline to v2.0.0 or higher.

2. Update the variables according to the variables section above.

3. Manually Removing Local Security Hub Standards for all account-baseline workspaces.

   Previous versions managed `aws_securityhub_standards_subscription` resources locally in the accounts. These are now centrally configured. **Terraform will attempt to remove these resources from the state**. To prevent disabling them, the resources must be manually removed from the Terraform state.

   _Steps to Remove Resources: Option 1: Using the Removed block:_

   ```hcl
   moved {
     from = module.account_baseline.aws_securityhub_standards_subscription.default["arn:aws:securityhub:eu-central-1::standards/pci-dss/v/3.2.1"]
     to   = module.account_baseline.aws_securityhub_standards_subscription.standards_pci_dss
   }

   removed {
     from =  module.account_baseline.aws_securityhub_standards_subscription.standards_pci_dss

     lifecycle {
       destroy = false
     }
   }

   moved {
     from = module.account_baseline.aws_securityhub_standards_subscription.default["arn:aws:securityhub:eu-central-1::standards/cis-aws-foundations-benchmark/v/1.4.0"]
     to   = module.account_baseline.aws_securityhub_standards_subscription.standards_cis_ws_foundations_benchmark
   }

   removed {
     from = module.account_baseline.aws_securityhub_standards_subscription.standards_cis_ws_foundations_benchmark

     lifecycle {
       destroy = false
     }
   }

   moved {
     from = module.account_baseline.aws_securityhub_standards_subscription.default["arn:aws:securityhub:eu-central-1::standards/aws-foundational-security-best-practices/v/1.0.0"]
     to   = module.account_baseline.aws_securityhub_standards_subscription.aws_foundational_security_best_practices
   }

   removed {
     from = module.account_baseline.aws_securityhub_standards_subscription.aws_foundational_security_best_practices

     lifecycle {
       destroy = false
     }
   }
   ```

   Note: you may need to alter the removed blocks based on the actually configured subscriptions and region.
   Note: the reason for first moving and then removing is because you cannot use "removed" blocks with a for_each loop

   _Steps to Remove Resources: Option 2: Using Terraform State manipulation_

   a. Generate Removal Commands. Run the following shell snippet:

   ```shell
   terraform init
   for local_standard in $(terraform state list | grep "module.account_baseline.aws_securityhub_standards_subscription"); do
     echo "terraform state rm '$local_standard'"
   done
   ```

   b. Execute Commands: Evaluate and run the generated statements. They will look like:

   ```shell
   terraform state rm 'module.account_baseline.aws_securityhub_standards_subscription["arn:aws:securityhub:eu-central-1::standards/pci-dss/v/3.2.1"]'
   ...
   ```

   _Why Manual Removal is Required_

   Terraform cannot handle `for_each` loops in `removed` blocks ([see #34439](https://github.com/hashicorp/terraform/issues/34439)). Therefore we could not add these removed statements in the module itself.
