# CHANGELOG

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/) and this project adheres to [Semantic Versioning](http://semver.org/).

## v4.0.0 - 2025-06-20

### What's Changed

#### 🚀 Features

* breaking: add enable_additional_eu_regions variable (#23) @marwinbaumannsbp

**Full Changelog**: https://github.com/schubergphilis/terraform-aws-mcaf-account-baseline/compare/v3.0.0...v4.0.0

## v3.0.0 - 2025-05-21

### What's Changed

#### 🚀 Features

* breaking: block public EC2 artifacts shares by default (#22) @carlovoSBP

#### 📖 Documentation

* docs: improve upgrading guide (#21) @marwinbaumannsbp

**Full Changelog**: https://github.com/schubergphilis/terraform-aws-mcaf-account-baseline/compare/v2.0.1...v3.0.0

## v2.0.1 - 2025-02-19

### What's Changed

#### 📖 Documentation

* docs: improve UPGRADING documentation because you cannot use REMOVED block with a for_each loop (#20) @macampo

**Full Changelog**: https://github.com/schubergphilis/terraform-aws-mcaf-account-baseline/compare/v2.0.0...v2.0.1

## v2.0.0 - 2025-01-16

### What's Changed

#### 🚀 Features

* breaking: remove aws_security_hub_standards_arns to support centralized security hub configuration (#19) @marwinbaumannsbp

**Full Changelog**: https://github.com/schubergphilis/terraform-aws-mcaf-account-baseline/compare/v1.1.0...v2.0.0

## v1.1.0 - 2025-01-14

### What's Changed

#### 🚀 Features

* feature: allow to configure the aws s3 account public access block (#18) @marwinbaumannsbp

**Full Changelog**: https://github.com/schubergphilis/terraform-aws-mcaf-account-baseline/compare/v1.0.1...v1.1.0

## v1.0.1 - 2024-01-02

### What's Changed

#### 📖 Documentation

* docs: improve service quotas manager documentation (#17) @marwinbaumannsbp

**Full Changelog**: https://github.com/schubergphilis/terraform-aws-mcaf-account-baseline/compare/v1.0.0...v1.0.1

## v1.0.0 - 2024-01-02

### What's Changed

#### 🚀 Features

* breaking: Control Tower 3.0 support (#15) @stefanwb

**Full Changelog**: https://github.com/schubergphilis/terraform-aws-mcaf-account-baseline/compare/v0.3.1...v1.0.0

## v0.3.1 - 2024-01-02

### What's Changed

#### 🐛 Bug Fixes

* bug: modify service quotas manager role name (#16) @marwinbaumannsbp

**Full Changelog**: https://github.com/schubergphilis/terraform-aws-mcaf-account-baseline/compare/v0.3.0...v0.3.1

## v0.3.0 - 2023-12-28

### What's Changed

#### 🚀 Features

* feat: add role to integrate with the terraform-aws-mcaf-service-quotas-manager module + formatting (#14) @marwinbaumannsbp

**Full Changelog**: https://github.com/schubergphilis/terraform-aws-mcaf-account-baseline/compare/v0.2.1...v0.3.0

## v0.2.1 - 2023-12-05

### What's Changed

#### 🐛 Bug Fixes

* bug: Fix `aws_cloudwatch_log_group` resource (#13) @shoekstra

**Full Changelog**: https://github.com/schubergphilis/terraform-aws-mcaf-account-baseline/compare/v0.2.0...v0.2.1

## v0.2.0 - 2023-07-25

### What's Changed

#### 🚀 Features

- feature: control the AWS Security Hub standards in member accounts (#12) @marwinbaumannsbp

**Full Changelog**: https://github.com/schubergphilis/terraform-aws-mcaf-account-baseline/compare/v0.1.5...v0.2.0

## v0.1.5 - 2023-05-01

### What's Changed

- remove workflow (#9) @shoekstra

#### 📖 Documentation

- docs: Docs review 2022-04 (#11) @shoekstra
- misc: set default value for `var.tags` (#10) @shoekstra

**Full Changelog**: https://github.com/schubergphilis/terraform-aws-mcaf-account-baseline/compare/v0.1.4...v0.1.5

## 0.1.4 (2022-10-02)

BUG FIXES

- Add count to `aws_cloudwatch_log_group.cloudtrail` data resource [#7](https://github.com/schubergphilis/terraform-aws-mcaf-account-baseline/pull/7))

## 0.1.3 (2022-09-09)

ENHANCEMENTS

- Update IAM activity filter [#6](https://github.com/schubergphilis/terraform-aws-mcaf-account-baseline/pull/6))

## 0.1.2 (2021-06-04)

BUG FIXES

- Fix `aws_ebs_default_kms_key` the count value depends on resource attributes that cannot be determined until apply [#5](https://github.com/schubergphilis/terraform-aws-mcaf-account-baseline/pull/5))

## 0.1.1 (2021-05-21)

- Add support for specifying the AWS KMS CMK to use to encrypt the EBS volumes ([#3](https://github.com/schubergphilis/terraform-aws-mcaf-account-baseline/pull/3))
- Improve tagging of resources ([#2](https://github.com/schubergphilis/terraform-aws-mcaf-account-baseline/pull/2))

## 0.1.0 (2021-02-26)

- First version ([#1](https://github.com/schubergphilis/terraform-aws-mcaf-account-baseline/pull/1))
