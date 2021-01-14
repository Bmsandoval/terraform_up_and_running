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
    key = "codepipeline/terraform.tfstate"
    region = "us-west-1"

    dynamodb_table = "terraform-up-and-running-locks"
    encrypt = true
  }
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_arns" "default" {


  vpc_id = data.aws_vpc.default.id
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
  pipeline_project_name = "terraform_up_and_running"
  region = var.aws_region
  environment = terraform.workspace
}

resource "aws_default_subnet" "default_az1" {
  availability_zone = "${local.region}a"

  tags = {
    Name = "Default subnet for ${local.region}a"
  }
}