variable "aws" {
  description = "aws setup"
  type = object({
    region             = string
    availability_zones = list(string)
  })
  default = {
    region             = "eu-north-1"
    availability_zones = ["eu-north-1a", "eu-north-1b"]
  }
}

variable "iam_role" {
  description = "iam role to assume for github actions"
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
  description = "github repository"
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

variable "nat" {
  description = "nat istance"
  type        = map(string)
  default = {
    type        = "t4g.nano",
    ami         = "ami-096a84b3b6234d916",
    volume_size = 8,
    volume_type = "gp3",
  }
}

variable "ec2" {
  description = "ec2 istance"
  type        = map(string)
  default = {
    type        = "t4g.nano",
    ami         = "ami-096a84b3b6234d916",
    volume_size = 8,
    volume_type = "gp3",
  }
}

variable "key" {
  description = "public key to ssh to ec2"
  type        = map(string)
  default = {
    key_name   = "aws_ec2_key"
    public_key = "~/.ssh/aws_ec2_key.pub"
  }
}

# Networking
variable "vpc" {
  description = "VPC with 2 public & 2 private subnets"
  type        = map(string)
  default = {
    default_cidr          = "0.0.0.0/0"
    vpc_cidr              = "10.0.0.0/20"
    public_subnet_1_cidr  = "10.0.0.0/24"
    public_subnet_2_cidr  = "10.0.1.0/24"
    private_subnet_1_cidr = "10.0.8.0/24"
    private_subnet_2_cidr = "10.0.9.0/24"
  }
}
