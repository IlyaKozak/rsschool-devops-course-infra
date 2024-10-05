resource "aws_default_route_table" "public_route_table" {
  default_route_table_id = aws_vpc.k8s_vpc.default_route_table_id

  route {
    cidr_block = var.vpc.default_cidr
    gateway_id = aws_internet_gateway.k8s_vpc_igw.id
  }

  tags = {
    Name = "public_k8s_route_table"
  }
}
resource "aws_route_table_association" "public_route_1_association" {
  route_table_id = aws_default_route_table.public_route_table.id
  subnet_id      = aws_subnet.public_subnet_1.id
}
resource "aws_route_table_association" "public_route_2_association" {
  route_table_id = aws_default_route_table.public_route_table.id
  subnet_id      = aws_subnet.public_subnet_2.id
}

resource "aws_route_table" "private_route_table_1" {
  vpc_id = aws_vpc.k8s_vpc.id

  route {
    cidr_block           = var.vpc.default_cidr
    network_interface_id = aws_network_interface.nat_network_interface.id
  }

  tags = {
    Name = "private_k8s_route_table_1"
  }
}
resource "aws_route_table_association" "private_route_1_association" {
  route_table_id = aws_route_table.private_route_table_1.id
  subnet_id      = aws_subnet.private_subnet_1.id
}

resource "aws_route_table" "private_route_table_2" {
  vpc_id = aws_vpc.k8s_vpc.id

  route {
    cidr_block           = var.vpc.default_cidr
    network_interface_id = aws_network_interface.nat_network_interface.id
  }

  tags = {
    Name = "private_k8s_route_table_2"
  }
}
resource "aws_route_table_association" "private_route_2_association" {
  route_table_id = aws_route_table.private_route_table_2.id
  subnet_id      = aws_subnet.private_subnet_2.id
}
