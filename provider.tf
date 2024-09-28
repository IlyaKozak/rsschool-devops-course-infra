terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.69"
    }
  }

  backend "s3" {
    bucket         = var.state_s3_bucket
    key            = var.state_s3_bucket_key
    dynamodb_table = var.state_dynamodb_table_lock
  }

  required_version = ">= 1.6"
}

provider "aws" {
  region = var.aws_region
}