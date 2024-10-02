resource "aws_vpc" "k8s-vpc" {
  cidr_block           = var.vpc.cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "k8s-vpc"
  }
}