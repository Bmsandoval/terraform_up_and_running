// because reasons
data "aws_region" "current" {}
// Used to get account_id
data "aws_caller_identity" "current" {}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 2.70"
    }
  }
}

terraform {
  backend "s3" {
    bucket = "splitnote-remote-state-bucket"
    key = "load_balancer/terraform.tfstate"
    region = "us-west-1"

    dynamodb_table = "splitnote-terraform-remote-state-locks"
    encrypt = true
  }
}

provider "aws" {
  profile = "default"
  region  = local.region
}

locals {
  # for elb_account_id, reference the table half way down the page on https://docs.aws.amazon.com/elasticloadbalancing/latest/classic/enable-access-logs.html
  aws_account_id = "531666410586"
  elb_account_id = var.aws_region == "us-west-1" ? "027434742980" : var.aws_region == "us-west-2" ? "797873946194" : ""
  company = var.company_name
  application = var.application_name
  account_id = data.aws_caller_identity.current.account_id
  region = var.aws_region
  environment = terraform.workspace
}
