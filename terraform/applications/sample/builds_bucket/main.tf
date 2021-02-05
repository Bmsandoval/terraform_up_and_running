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
    key = "builds_bucket/terraform.tfstate"
    region = "us-west-1"

    dynamodb_table = "splitnote-terraform-remote-state-locks"
    encrypt = true
  }
}

provider "aws" {
  profile = "default"
  region  = local.region
}

// because reasons
data "aws_region" "current" {}
// Used to get account_id
data "aws_caller_identity" "current" {}

locals {
  company = var.company_name
  application = var.application_name
  account_id = data.aws_caller_identity.current.account_id
  region = var.aws_region
  environment = terraform.workspace
}
