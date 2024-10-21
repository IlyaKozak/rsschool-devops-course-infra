resource "aws_instance" "ec2" {
  ami             = var.ec2.ami
  instance_type   = var.ec2.type
  count           = 3
  key_name        = aws_key_pair.ssh.key_name
  subnet_id       = element([aws_subnet.private_1.id, aws_subnet.private_2.id, aws_subnet.public_2.id], count.index)
  security_groups = [aws_security_group.ec2.id]

  root_block_device {
    volume_size = var.ec2.volume_size
    volume_type = var.ec2.volume_type
  }
}