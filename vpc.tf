resource "aws_vpc" "k8s-vpc" {
  cidr_block           = var.vpc.cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "k8s-vpc"
  }
}

resource "aws_subnet" "public-subnet-1" {
  cidr_block        = var.vpc.public_subnet_1_cidr
  vpc_id            = aws_vpc.k8s-vpc.id
  availability_zone = var.aws.availability_zones[0]
  tags = {
    Name = "public-k8s-subnet-1"
  }
}
resource "aws_subnet" "public-subnet-2" {
  cidr_block        = var.vpc.public_subnet_2_cidr
  vpc_id            = aws_vpc.k8s-vpc.id
  availability_zone = var.aws.availability_zones[1]
  tags = {
    Name = "public-k8s-subnet-2"
  }
}