variable "aws_region" {
  description = "aws region to deploy resources"
  type        = string
  default     = "eu-north-1"
}

variable "iam_role_name" {
  description = "iam role name for github actions"
  type        = string
  default     = "GithubActionsRole"
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
    thumbprints = list(string)
  })
  default = {
    domain      = "token.actions.githubusercontent.com"
    thumbprints = ["6938fd4d98bab03faadb97b34396831e3780aea1", "1c58a3a8518e8759bf075b76b750d4f2df264fcd"]
  }
}


