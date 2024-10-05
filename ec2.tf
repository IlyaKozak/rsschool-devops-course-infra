resource "aws_instance" "ec2_private" {
  ami             = var.nat.ami
  instance_type   = var.nat.type
  count           = 2
  key_name        = aws_key_pair.ssh.key_name
  subnet_id       = element([aws_subnet.private-subnet-1.id, aws_subnet.private-subnet-2.id], count.index)
  security_groups = [aws_security_group.ec2_private.id]

  tags = {
    Name = "ec2_private"
  }
}