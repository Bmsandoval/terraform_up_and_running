terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 2.70"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = local.region
}

variable "aws_region" {}

// because reasons
data "aws_region" "current" {}
// Used to get account_id
data "aws_caller_identity" "current" {}

locals {
  company = "splitnote"
  account_id = data.aws_caller_identity.current.account_id
  region = var.aws_region
  environment = terraform.workspace
}
