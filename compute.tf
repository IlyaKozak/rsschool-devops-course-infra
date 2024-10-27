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
  ami           = data.aws_ami.amazon_linux_2023_latest.id
  instance_type = var.ec2.small_type
  subnet_id     = aws_subnet.private_1.id

  key_name             = aws_key_pair.ssh.key_name
  security_groups      = [aws_security_group.ec2_vpc.id]
  iam_instance_profile = aws_iam_instance_profile.ebs_csi_instance_profile.name

  user_data = templatefile("user_data_k3s_server.sh", {
    token               = var.token,
    jenkins_ebs_id      = aws_ebs_volume.jenkins.id,
    jenkins_nodeport    = var.jenkins.nodeport,
    jenkins_pv          = var.jenkins.pv,
    jenkins_pvc         = var.jenkins.pvc,
    jenkins_volume_size = var.jenkins.volume_size,
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
  depends_on = [aws_instance.k3s_server]

  ami           = data.aws_ami.amazon_linux_2023_latest.id
  instance_type = var.ec2.nano_type
  subnet_id     = aws_subnet.private_2.id

  key_name        = aws_key_pair.ssh.key_name
  security_groups = [aws_security_group.ec2_vpc.id]

  user_data = templatefile("user_data_k3s_agent.sh", {
    token                 = var.token,
    k3s_server_private_ip = aws_instance.k3s_server.private_ip,
  })

  root_block_device {
    volume_size = var.ec2.volume_size
    volume_type = var.ec2.volume_type
  }

  tags = {
    Name = "k3s_agent"
    Role = "k3s"
  }
}
