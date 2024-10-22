data "aws_ami" "amazon_linux_2023_latest" {
  most_recent = true

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["al2023-ami-2023*-arm64"]
  }

  filter {
    name   = "architecture"
    values = ["arm64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "k3s_server" {
  ami             = data.aws_ami.amazon_linux_2023_latest.id
  instance_type   = var.ec2.micro_type
  key_name        = aws_key_pair.ssh.key_name
  subnet_id       = aws_subnet.private_1.id
  security_groups = [aws_security_group.ec2_vpc.id]
  user_data = templatefile("user_data_k3s_server.sh", {
    token = var.token
  })

  root_block_device {
    volume_size = var.ec2.volume_size
    volume_type = var.ec2.volume_type
  }

  tags = {
    Name = "k3s_server"
    Role = "k3s"
  }
}

resource "aws_instance" "k3s_agent" {
  ami             = data.aws_ami.amazon_linux_2023_latest.id
  instance_type   = var.ec2.nano_type
  key_name        = aws_key_pair.ssh.key_name
  subnet_id       = aws_subnet.private_2.id
  security_groups = [aws_security_group.ec2_vpc.id]
  user_data = templatefile("user_data_k3s_agent.sh", {
    token                 = var.token,
    k3s_server_private_ip = aws_instance.k3s_server.private_ip
  })
  depends_on = [aws_instance.k3s_server]

  root_block_device {
    volume_size = var.ec2.volume_size
    volume_type = var.ec2.volume_type
  }

  tags = {
    Name = "k3s_agent"
    Role = "k3s"
  }
}
