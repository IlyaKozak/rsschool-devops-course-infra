resource "aws_default_route_table" "public-route-table" {
  default_route_table_id = aws_vpc.k8s-vpc.default_route_table_id

  route {
    cidr_block = var.vpc.default_cidr
    gateway_id = aws_internet_gateway.k8s-vpc-igw.id
  }

  tags = {
    Name = "public-k8s-route-table"
  }
}
resource "aws_route_table_association" "public-route-1-association" {
  route_table_id = aws_default_route_table.public-route-table.id
  subnet_id      = aws_subnet.public-subnet-1.id
}
resource "aws_route_table_association" "public-route-2-association" {
  route_table_id = aws_default_route_table.public-route-table.id
  subnet_id      = aws_subnet.public-subnet-2.id
}

resource "aws_route_table" "private-route-table-1" {
  vpc_id = aws_vpc.k8s-vpc.id

  route {
    cidr_block           = var.vpc.default_cidr
    network_interface_id = aws_network_interface.nat_network_interface.id
  }

  tags = {
    Name = "private-k8s-route-table-1"
  }
}
resource "aws_route_table_association" "private-route-1-association" {
  route_table_id = aws_route_table.private-route-table-1.id
  subnet_id      = aws_subnet.private-subnet-1.id
}

resource "aws_route_table" "private-route-table-2" {
  vpc_id = aws_vpc.k8s-vpc.id

  route {
    cidr_block           = var.vpc.default_cidr
    network_interface_id = aws_network_interface.nat_network_interface.id
  }

  tags = {
    Name = "private-k8s-route-table-2"
  }
}
resource "aws_route_table_association" "private-route-2-association" {
  route_table_id = aws_route_table.private-route-table-2.id
  subnet_id      = aws_subnet.private-subnet-2.id
}
