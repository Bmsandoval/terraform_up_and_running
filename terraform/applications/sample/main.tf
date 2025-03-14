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
    key = "global/terraform.tfstate"
    region = "us-west-1"

    dynamodb_table = "splitnote-terraform-remote-state-locks"
    encrypt = true
  }
}

data "terraform_remote_state" "load_balancer" {
  backend = "s3"
  workspace = terraform.workspace

  config = {
    bucket = "splitnote-remote-state-bucket"
    key = "load_balancer/terraform.tfstate"
    region = "us-west-1"
  }
}

data "terraform_remote_state" "builds_bucket" {
  backend = "s3"
  workspace = terraform.workspace

  config = {
    bucket = "splitnote-remote-state-bucket"
    key = "builds_bucket/terraform.tfstate"
    region = "us-west-1"
  }
}

provider "aws" {
  profile = "default"
  region  = local.region
}

locals {
  company = var.company_name
  application = var.application_name
  environment = terraform.workspace
  region = var.aws_region
  port = var.server_port
}

