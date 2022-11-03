# CHANGELOG

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/) and this project adheres to [Semantic Versioning](http://semver.org/).

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
