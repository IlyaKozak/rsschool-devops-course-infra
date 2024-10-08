resource "aws_network_acl" "k8s-public" {
  vpc_id = aws_vpc.k8s.id
  subnet_ids = [
    aws_subnet.public_1.id,
    aws_subnet.public_2.id,
  ]

  ingress {
    rule_no    = 100
    action     = "allow"
    protocol   = -1
    cidr_block = var.vpc.default_cidr
    from_port  = 0
    to_port    = 0
  }

  egress {
    rule_no    = 100
    action     = "allow"
    protocol   = -1
    cidr_block = var.vpc.default_cidr
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name = "k8s-network-acl-public"
  }
}

resource "aws_network_acl" "k8s-private" {
  vpc_id = aws_vpc.k8s.id
  subnet_ids = [
    aws_subnet.private_1.id,
    aws_subnet.private_2.id,
  ]

  ingress {
    rule_no    = 100
    action     = "allow"
    protocol   = -1
    cidr_block = var.vpc.default_cidr
    from_port  = 0
    to_port    = 0
  }

  egress {
    rule_no    = 100
    action     = "allow"
    protocol   = -1
    cidr_block = var.vpc.default_cidr
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name = "k8s-network-acl-private"
  }
}
