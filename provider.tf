terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.69"
    }
  }

  # backend "s3" {
  #   bucket         = ""
  #   key            = ""
  #   dynamodb_table = ""
  # }

  required_version = ">= 1.6"
}

provider "aws" {
  region = var.aws_region
}