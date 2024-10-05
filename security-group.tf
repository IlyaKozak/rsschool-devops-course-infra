resource "aws_security_group" "ec2_nat" {
  name        = "nat_instance_security_group"
  description = "Bastion host and NAT - allows ssh jump to private subnets instances and inbound access from private subnets to Internet"
  vpc_id      = aws_vpc.k8s-vpc.id

  ingress {
    from_port   = var.ports.ssh
    to_port     = var.ports.ssh
    protocol    = var.protocols.tcp
    cidr_blocks = [var.vpc.default_cidr]
  }

  ingress {
    from_port   = var.ports.all
    to_port     = var.ports.all
    protocol    = var.protocols.icmp
    cidr_blocks = [var.vpc.private_subnet_1_cidr, var.vpc.private_subnet_2_cidr]
  }

  ingress {
    from_port   = var.ports.http
    to_port     = var.ports.http
    protocol    = var.protocols.tcp
    cidr_blocks = [var.vpc.private_subnet_1_cidr, var.vpc.private_subnet_2_cidr]
  }

  ingress {
    from_port   = var.ports.https
    to_port     = var.ports.https
    protocol    = var.protocols.tcp
    cidr_blocks = [var.vpc.private_subnet_1_cidr, var.vpc.private_subnet_2_cidr]
  }

  egress {
    from_port   = var.ports.ssh
    to_port     = var.ports.ssh
    protocol    = var.protocols.tcp
    cidr_blocks = [var.vpc.private_subnet_1_cidr, var.vpc.private_subnet_2_cidr]
  }

  egress {
    from_port   = var.ports.all
    to_port     = var.ports.all
    protocol    = var.protocols.icmp
    cidr_blocks = [var.vpc.default_cidr]
  }

  egress {
    from_port   = var.ports.http
    to_port     = var.ports.http
    protocol    = var.protocols.tcp
    cidr_blocks = [var.vpc.default_cidr]
  }

  egress {
    from_port   = var.ports.https
    to_port     = var.ports.https
    protocol    = var.protocols.tcp
    cidr_blocks = [var.vpc.default_cidr]
  }
}


resource "aws_security_group" "ec2_private" {
  name        = "ec2_private_security_group"
  description = "allows ssh ingress from bastion host and egress to NAT"
  vpc_id      = aws_vpc.k8s-vpc.id

  ingress {
    from_port   = var.ports.ssh
    to_port     = var.ports.ssh
    protocol    = var.protocols.tcp
    cidr_blocks = [for nat in aws_instance.nat_instance_bastion_host : "${nat.private_ip}/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = var.protocols.all
    cidr_blocks = [var.vpc.default_cidr]
  }
}