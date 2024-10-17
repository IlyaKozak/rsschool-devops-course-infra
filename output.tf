output "key_pair" {
  description = "key pair"
  value = {
    private_key = "${tls_private_key.ssh.private_key_pem}",
    public_key  = "${tls_private_key.ssh.public_key_pem}"
  }
  sensitive = true
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

output "k3s_cluster" {
  description = "k3s_cluster"
  value = {
    k3s_server = "${aws_instance.k3s_server.private_ip}"
    k3s_agent  = "${aws_instance.k3s_agent.private_ip}"
  }
}