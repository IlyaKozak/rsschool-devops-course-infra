resource "aws_iam_openid_connect_provider" "oidc" {
  url = "https://${var.oidc_provider_domain}"

  client_id_list = [
    "sts.amazonaws.com",
  ]

  thumbprint_list = [var.oidc_thumbprint_1, var.oidc_thumbprint_2]
}