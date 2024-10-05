resource "aws_network_acl" "k8s-network-acl" {
  vpc_id = aws_vpc.k8s_vpc.id

  ingress {
    rule_no    = 100
    action     = "allow"
    protocol   = var.protocols.all
    cidr_block = var.vpc.default_cidr
    from_port  = var.ports.zero
    to_port    = var.ports.zero
  }

  egress {
    rule_no    = 100
    action     = "allow"
    protocol   = var.protocols.all
    cidr_block = var.vpc.default_cidr
    from_port  = var.ports.zero
    to_port    = var.ports.zero
  }

  tags = {
    Name = "k8s-network-acl"
  }
}

data "aws_subnet" "public_subnet_1" {
  filter {
    name   = "tag:Name"
    values = ["public_k8s_subnet_1"]
  }
}

data "aws_subnet" "public_subnet_2" {
  filter {
    name   = "tag:Name"
    values = ["public_k8s_subnet_2"]
  }
}

data "aws_subnet" "private_subnet_1" {
  filter {
    name   = "tag:Name"
    values = ["private_k8s_subnet_1"]
  }
}

data "aws_subnet" "private_subnet_2" {
  filter {
    name   = "tag:Name"
    values = ["private_k8s_subnet_2"]
  }
}

locals {
  subnet_ids = [
    data.aws_subnet.public_subnet_1.id,
    data.aws_subnet.public_subnet_2.id,
    data.aws_subnet.private_subnet_1.id,
    data.aws_subnet.private_subnet_2.id
  ]
}

resource "aws_network_acl_association" "acl_associations" {
  for_each       = toset(local.subnet_ids)
  subnet_id      = each.value
  network_acl_id = aws_network_acl.k8s-network-acl.id
}