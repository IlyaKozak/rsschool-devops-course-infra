output "key_pair" {
  description = "key pair"
  value = {
    private_key = "${tls_private_key.ssh.private_key_pem}",
    public_key  = "${tls_private_key.ssh.public_key_pem}"
  }
  sensitive = true
}

output "subnets" {
  description = "subnets"
  value = {
    public_subnet_1  = "${aws_subnet.public_1.id}",
    public_subnet_2  = "${aws_subnet.public_2.id}",
    private_subnet_1 = "${aws_subnet.private_1.id}",
    private_subnet_2 = "${aws_subnet.private_2.id}",
  }
}

output "elastic_ip" {
  description = "elastic ip for NAT"
  value       = aws_eip.nat.public_ip
}

output "nat_instances" {
  description = "details of the NAT instance"
  value = [
    for nat in aws_instance.nat_bastion_host : {
      public_ip  = nat.public_ip
      private_ip = nat.private_ip
      subnet_id  = nat.subnet_id
    }
  ]
}

output "ec2_instances" {
  description = "details of the EC2 instances"
  value = [
    for instance in aws_instance.ec2 : {
      public_ip  = instance.public_ip
      private_ip = instance.private_ip
      subnet_id  = instance.subnet_id
    }
  ]
}
