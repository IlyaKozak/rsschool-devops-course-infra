resource "aws_network_acl" "k8s-network-acl" {
  vpc_id = aws_vpc.k8s_vpc.id

  ingress {
    rule_no    = 100
    action     = "allow"
    protocol   = var.protocols.all
    cidr_block = var.vpc.default_cidr
    from_port  = var.ports.all
    to_port    = var.ports.all
  }

  egress {
    rule_no    = 100
    action     = "allow"
    protocol   = var.protocols.all
    cidr_block = var.vpc.default_cidr
    from_port  = var.ports.all
    to_port    = var.ports.all
  }

  tags = {
    Name = "k8s-network-acl"
  }
}

variable "subnet_ids" {
  type = set(string)
  default = [
    aws_subnet.public_subnet_1.id,
    aws_subnet.public_subnet_2.id,
    aws_subnet.private_subnet_1.id,
    aws_subnet.private_subnet_2.id
  ]
}

resource "aws_network_acl_association" "acl_associations" {
  for_each      = var.subnet_ids
  subnet_id     = each.value
  network_acl_id = aws_network_acl.k8s-network-acl.id
}