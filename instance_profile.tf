resource "aws_iam_instance_profile" "k3s" {
  name = "k3sServerInstanceProfile"
  role = aws_iam_role.k3s.name
}

resource "aws_iam_role" "k3s" {
  name = "k3sServerRole"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "ec2.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "k3s" {
  for_each = var.k3s_instance_profile.policies

  role       = aws_iam_role.k3s.name
  policy_arn = each.value
}
