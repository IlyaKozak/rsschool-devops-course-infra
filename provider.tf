terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.69"
    }
  }

  backend "s3" {
    bucket         = "terraform-20240929182351330400000001"
    key            = "terraform/state"
    dynamodb_table = "aws-devops-terraform-state-lock"
    region         = "eu-north-1"
  }

  required_version = ">= 1.6"
}

provider "aws" {
  region = var.aws_region
}