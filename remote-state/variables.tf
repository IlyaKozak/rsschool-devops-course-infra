variable "aws_region" {
  description = "aws region to deploy resources"
  type        = string
  default     = "eu-north-1"
}

variable "dynamodb_table_name" {
  description = "dynamodb table name"
  type        = string
  default     = "aws-devops-terraform-state-lock"
}