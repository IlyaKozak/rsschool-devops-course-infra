terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.69"
    }
  }

  required_version = ">= 1.6"
}

provider "aws" {
  region = var.aws_region
}

resource "aws_iam_openid_connect_provider" "github_actions_oidc" {
  url = "https://${var.github_actions_oidc_domain}"

  client_id_list = [
    "sts.amazonaws.com",
  ]

  thumbprint_list = [var.github_actions_oidc_thumbprint_1, var.github_actions_oidc_thumbprint_2]
}

data "aws_iam_policy_document" "github_actions_policy_doc" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github_actions_oidc.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${var.github_actions_oidc_domain}:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringLike"
      variable = "${var.github_actions_oidc_domain}:sub"
      values   = ["repo:${var.github_org}/${var.github_org}:*"]
    }
  }
}

resource "aws_iam_role" "github_actions_role" {
  name               = var.iam_role_name
  assume_role_policy = data.aws_iam_policy_document.github_actions_policy_doc.json
}

resource "aws_iam_role_policy_attachment" "role-policy-attachment" {
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonEC2FullAccess",
    "arn:aws:iam::aws:policy/AmazonRoute53FullAccess",
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/IAMFullAccess",
    "arn:aws:iam::aws:policy/AmazonVPCFullAccess",
    "arn:aws:iam::aws:policy/AmazonSQSFullAccess",
    "arn:aws:iam::aws:policy/AmazonEventBridgeFullAccess",
  ])

  role       = aws_iam_role.github_actions_role.name
  policy_arn = each.value
}