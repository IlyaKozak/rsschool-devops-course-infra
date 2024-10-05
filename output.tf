# output "public_ip" {
#   value = aws_eip.nat_instance_ip.public_ip
# }

output "private_key" {
  value     = tls_private_key.ssh.private_key_pem
  sensitive = true
}

output "public_key" {
  value = tls_private_key.ssh.public_key_pem
}