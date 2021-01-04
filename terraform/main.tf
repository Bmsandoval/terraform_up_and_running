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

    dynamodb_table = "terraform-up-and-running-locks"
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

provider "aws" {
  profile = "default"
  region  = local.region
}

locals {
  environment = terraform.workspace
  region = var.aws_region
  port = var.server_port
}

