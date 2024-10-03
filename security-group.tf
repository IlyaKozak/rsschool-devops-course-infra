resource "aws_security_group" "ec2_nat" {
  name        = "nat_instance_security_group"
  description = "allows inbound access from private subnets and ssh"
  vpc_id      = aws_vpc.k8s-vpc.id

  ingress {
    from_port   = var.ports.ssh
    to_port     = var.ports.ssh
    protocol    = var.protocols.tcp
    cidr_blocks = [var.vpc.default_cidr]
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