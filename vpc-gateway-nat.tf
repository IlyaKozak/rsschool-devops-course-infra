resource "aws_internet_gateway" "k8s-vpc-igw" {
  vpc_id = aws_vpc.k8s-vpc.id
  tags = {
    Name = "k8s-igw"
  }
}

resource "aws_network_interface" "nat_network_interface" {
  subnet_id         = aws_subnet.public-subnet-1.id
  source_dest_check = false
  security_groups   = [aws_security_group.ec2_nat.id]

  tags = {
    Name = "nat_instance_network_interface"
  }
}

# resource "aws_eip" "nat_instance_ip" {
#   network_interface = aws_network_interface.nat_network_interface.id
#   depends_on        = [aws_instance.nat_instance_bastion_host, aws_network_interface.nat_network_interface]
# }

# resource "aws_instance" "nat_instance_bastion_host" {
#   ami           = var.nat.ami
#   instance_type = var.nat.type
#   count         = 1
#   key_name      = aws_key_pair.ssh.key_name
#   network_interface {
#     network_interface_id = aws_network_interface.nat_network_interface.id
#     device_index         = 0
#   }
#   user_data = file("user_data.sh")

#   tags = {
#     Name = "nat_instance"
#     Role = "nat"
#   }
# }