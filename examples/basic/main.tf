provider "aws" {
  region = "eu-west-1"
}

module "account-baseline" {
  source = "../.."
}
