resource "aws_instance" "ec2_private" {
  ami             = var.ec2.ami
  instance_type   = var.ec2.type
  count           = 2
  key_name        = aws_key_pair.ssh.key_name
  subnet_id       = element([aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id], count.index)
  security_groups = [aws_security_group.ec2_private.id]

  root_block_device {
    volume_size = var.ec2.volume_size
    volume_type = var.ec2.volume_type
  }

  tags = {
    Name = "ec2_private"
  }
}