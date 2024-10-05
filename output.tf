output "private_key" {
  value     = tls_private_key.ssh.private_key_pem
  sensitive = true
}

output "public_key" {
  value = tls_private_key.ssh.public_key_pem
}

output "nat_public_ip" {
  value = aws_eip.nat_instance_ip.public_ip
}

output "nat_private_ip" {
  value = aws_eip.nat_instance_ip.private_ip
}

output "ec2_private" {
  value = [for instance in aws_instance.ec2_private : instance.private_ip]
}