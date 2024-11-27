terraform {
  required_version = "~> 1.0"
  backend "s3" {}
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.71"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.6"
    }
  }
}


provider "aws" {
  region = var.aws_region
  default_tags {
    tags = merge(var.tags, {
      "Environment" = var.environment
      "Terraform"   = "true"
    })
  }
}
