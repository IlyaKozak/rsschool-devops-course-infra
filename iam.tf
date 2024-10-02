resource "aws_iam_openid_connect_provider" "oidc" {
  url = "https://${var.oidc_provider.domain}"

  client_id_list = [
    var.oidc_provider.audience,
  ]

  thumbprint_list = var.oidc_provider.thumbprints
}

resource "aws_iam_role" "github_actions_role" {
  name               = var.iam_role.name
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
      values   = [var.oidc_provider.audience]
    }

    condition {
      test     = "StringLike"
      variable = "${var.oidc_provider.domain}:sub"
      values   = ["repo:${var.github.org}/${var.github.repo}:*"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "policy-attach" {
  for_each = var.iam_role.policies

  role       = aws_iam_role.github_actions_role.name
  policy_arn = each.value
}