resource "aws_key_pair" "ec2_key" {
  key_name   = var.key.key_name
  public_key = file(var.key.public_key)
}