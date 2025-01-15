# Upgrading Notes

This document captures required refactoring on your part when upgrading to a module version that contains breaking changes.

## Upgrading to v2.0.0

### Key Changes

#### Transition to Centralized Security Hub Configuration

This version relies on the centralized security hub configuration as added in [terraform-aws-mcaf-landing-zone version v5.0.0](https://github.com/schubergphilis/terraform-aws-mcaf-landing-zone/releases/tag/v5.0.0)  

Using centralized security hub it's no longer possible to modify the AWS SecurityHub standards in the account itself, therefore this functionality has been removed from this module. 


### Variables

The following variables have been removed:
* `aws_security_hub_standards_arns`. This variable is not configurable anymore using security hub central configuration.

### How to upgrade.

1. Upgrade your landing zone deployment to v5.0.0 or higher FIRST, before updating your account-baseline to v2.0.0 or higher.

2. Update the variables according to the variables section above. 

3. Manually Removing Local Security Hub Standards for all account-baseline workspaces.

    Previous versions managed `aws_securityhub_standards_subscription` resources locally in the accounts. These are now centrally configured. **Terraform will attempt to remove these resources from the state**. To prevent disabling them, the resources must be manually removed from the Terraform state.

    *Steps to Remove Resources: Option 1: Using the Removed block:*

    ```
    removed {
      from = module.account_baseline.aws_securityhub_standards_subscription["arn:aws:securityhub:eu-central-1::standards/pci-dss/v/3.2.1"]

      lifecycle {
        destroy = false
      }
    }

    removed {
      from = module.account_baseline.aws_securityhub_standards_subscription["arn:aws:securityhub:eu-central-1::standards/cis-aws-foundations-benchmark/v/1.4.0"]

      lifecycle {
        destroy = false
      }
    }

    removed {
      from = module.account_baseline.aws_securityhub_standards_subscription["aws-foundational-security-best-practices/v/1.0.0"]

      lifecycle {
        destroy = false
      }
    }
    ```

    Note: you may need to alter the removed blocks based on the actually configured subscriptions.


    *Steps to Remove Resources: Option 2: Using Terraform State manipulation*

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

    *Why Manual Removal is Required*

    Terraform cannot handle `for_each` loops in `removed` statements ([HashiCorp Issue #34439](https://github.com/hashicorp/terraform/issues/34439)). Therefore we could not add these removed statements in the module itself. 
