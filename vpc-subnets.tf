resource "aws_vpc" "k8s_vpc" {
  cidr_block           = var.vpc.cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "k8s_vpc"
  }
}

resource "aws_subnet" "public_subnet_1" {
  cidr_block              = var.vpc.public_subnet_1_cidr
  vpc_id                  = aws_vpc.k8s_vpc.id
  availability_zone       = var.aws.availability_zones[0]
  map_public_ip_on_launch = true
  tags = {
    Name = "public_k8s_subnet_1"
  }
}
resource "aws_subnet" "public_subnet_2" {
  cidr_block              = var.vpc.public_subnet_2_cidr
  vpc_id                  = aws_vpc.k8s_vpc.id
  availability_zone       = var.aws.availability_zones[1]
  map_public_ip_on_launch = true
  tags = {
    Name = "public_k8s_subnet_2"
  }
}

resource "aws_subnet" "private_subnet_1" {
  tags = {
    Name = "private_k8s_subnet_1"
  }
  cidr_block        = var.vpc.private_subnet_1_cidr
  vpc_id            = aws_vpc.k8s_vpc.id
  availability_zone = var.aws.availability_zones[0]
}
resource "aws_subnet" "private_subnet_2" {
  tags = {
    Name = "private_k8s_subnet_2"
  }
  cidr_block        = var.vpc.private_subnet_2_cidr
  vpc_id            = aws_vpc.k8s_vpc.id
  availability_zone = var.aws.availability_zones[1]
}
