resource "aws_iam_instance_profile" "ebs_csi_instance_profile" {
  name = "EbsCsiInstanceProfile"
  role = aws_iam_role.ebs_csi_driver_role.name
}

resource "aws_iam_role" "ebs_csi_driver_role" {
  name = "EbsCsiDriverRole"

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

resource "aws_iam_role_policy_attachment" "ebs_csi_driver_attachment" {
  role       = aws_iam_role.ebs_csi_driver_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}
