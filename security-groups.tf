resource "aws_security_group" "ec2_nat" {
  name        = "nat_instance_security_group"
  description = "Bastion host and NAT - allows ssh jump to private subnets instances and inbound access from private subnets to Internet"
  vpc_id      = aws_vpc.k8s.id

  ingress {
    description = "ping"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [var.vpc.default_cidr]
  }

  ingress {
    description = "ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.vpc.default_cidr]
  }

  ingress {
    description = "http"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.vpc.private_subnet_1_cidr, var.vpc.private_subnet_2_cidr]
  }

  ingress {
    description = "https"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc.private_subnet_1_cidr, var.vpc.private_subnet_2_cidr]
  }

  egress {
    description = "ping"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [var.vpc.default_cidr]
  }

  egress {
    description = "ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.vpc.vpc_cidr]
  }

  egress {
    description = "http"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.vpc.default_cidr]
  }

  egress {
    description = "https"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc.default_cidr]
  }
}


resource "aws_security_group" "ec2" {
  name        = "ec2_security_group"
  description = "allows ingress from vpc and egress to everywhere"
  vpc_id      = aws_vpc.k8s.id

  ingress {
    description = "ingress from vpc subnets"
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = [var.vpc.vpc_cidr]
  }

  egress {
    description = "egress everywhere"
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = [var.vpc.default_cidr]
  }
}