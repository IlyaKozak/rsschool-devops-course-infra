resource "aws_iam_openid_connect_provider" "oidc" {
  url = "https://${var.oidc_provider.domain}"

  client_id_list = [
    "sts.amazonaws.com",
  ]

  thumbprint_list = var.oidc_provider.thumbprints
}

resource "aws_iam_role" "github_actions_role" {
  name               = var.iam_role_name
  assume_role_policy = data.aws_iam_policy_document.policy_doc.json
}

data "aws_iam_policy_document" "policy_doc" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.oidc.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${var.oidc_provider.domain}:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringLike"
      variable = "${var.oidc_provider.domain}:sub"
      values   = ["repo:${var.github.org}/${var.github.repo}:*"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "policy-attach" {
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonEC2FullAccess",
    "arn:aws:iam::aws:policy/AmazonRoute53FullAccess",
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/IAMFullAccess",
    "arn:aws:iam::aws:policy/AmazonVPCFullAccess",
    "arn:aws:iam::aws:policy/AmazonSQSFullAccess",
    "arn:aws:iam::aws:policy/AmazonEventBridgeFullAccess",
    "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess",
  ])

  role       = aws_iam_role.github_actions_role.name
  policy_arn = each.value
}