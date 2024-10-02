variable "aws_region" {
  description = "aws region to deploy resources"
  type        = string
  default     = "eu-north-1"
}

variable "iam_role" {
  description = "iam role for github actions"
  type = object({
    name     = string
    policies = set(string)
  })
  default = {
    name = "GithubActionsRole"
    policies = [
      "arn:aws:iam::aws:policy/AmazonEC2FullAccess",
      "arn:aws:iam::aws:policy/AmazonRoute53FullAccess",
      "arn:aws:iam::aws:policy/AmazonS3FullAccess",
      "arn:aws:iam::aws:policy/IAMFullAccess",
      "arn:aws:iam::aws:policy/AmazonVPCFullAccess",
      "arn:aws:iam::aws:policy/AmazonSQSFullAccess",
      "arn:aws:iam::aws:policy/AmazonEventBridgeFullAccess",
      "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess",
    ]
  }
}

variable "github" {
  description = "github repository setup"
  default = {
    "org"  = "IlyaKozak"
    "repo" = "rsschool-devops-course-tasks"
  }
  type = map(string)
}

variable "oidc_provider" {
  description = "github actions OIDC provider"
  type = object({
    domain      = string
    audience    = string
    thumbprints = list(string)
  })
  default = {
    domain      = "token.actions.githubusercontent.com"
    audience    = "sts.amazonaws.com"
    thumbprints = ["6938fd4d98bab03faadb97b34396831e3780aea1", "1c58a3a8518e8759bf075b76b750d4f2df264fcd"]
  }
}


