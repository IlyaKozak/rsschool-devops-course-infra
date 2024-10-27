resource "aws_internet_gateway" "k8s_vpc_igw" {
  vpc_id = aws_vpc.k8s.id
  tags = {
    Name = "k8s_igw"
  }
}

resource "aws_network_interface" "nat" {
  subnet_id         = aws_subnet.public_1.id
  source_dest_check = false
  security_groups   = [aws_security_group.ec2_nat.id]

  tags = {
    Name = "nat_instance_network_interface"
  }
}

resource "aws_eip" "nat" {
  depends_on = [aws_instance.nat_bastion_host, aws_network_interface.nat]

  network_interface = aws_network_interface.nat.id
}

resource "aws_instance" "nat_bastion_host" {
  count = 1

  ami           = data.aws_ami.amazon_linux_2023_latest.id
  instance_type = var.nat.type
  key_name      = aws_key_pair.ssh.key_name

  user_data = templatefile("user_data_nat.sh", {
    k3s_server_private_ip = aws_instance.k3s_server.private_ip
  })

  network_interface {
    network_interface_id = aws_network_interface.nat.id
    device_index         = 0
  }

  root_block_device {
    volume_size = var.nat.volume_size
    volume_type = var.nat.volume_type
  }

  tags = {
    Name = "nat_instance"
    Role = "nat"
  }
}