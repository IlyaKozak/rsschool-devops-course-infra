resource "aws_default_route_table" "public" {
  default_route_table_id = aws_vpc.k8s.default_route_table_id

  route {
    cidr_block = var.vpc.default_cidr
    gateway_id = aws_internet_gateway.k8s_vpc_igw.id
  }

  tags = {
    Name = "public_k8s_route_table"
  }
}
resource "aws_route_table_association" "public_1" {
  route_table_id = aws_default_route_table.public.id
  subnet_id      = aws_subnet.public_1.id
}
resource "aws_route_table_association" "public_2" {
  route_table_id = aws_default_route_table.public.id
  subnet_id      = aws_subnet.public_2.id
}

resource "aws_route_table" "private_1" {
  vpc_id = aws_vpc.k8s.id

  route {
    cidr_block           = var.vpc.default_cidr
    network_interface_id = aws_network_interface.nat.id
  }

  tags = {
    Name = "private_k8s_route_table_1"
  }
}
resource "aws_route_table_association" "private_1" {
  route_table_id = aws_route_table.private_1.id
  subnet_id      = aws_subnet.private_1.id
}

resource "aws_route_table" "private_2" {
  vpc_id = aws_vpc.k8s.id

  route {
    cidr_block           = var.vpc.default_cidr
    network_interface_id = aws_network_interface.nat.id
  }

  tags = {
    Name = "private_k8s_route_table_2"
  }
}
resource "aws_route_table_association" "private_2" {
  route_table_id = aws_route_table.private_2.id
  subnet_id      = aws_subnet.private_2.id
}
