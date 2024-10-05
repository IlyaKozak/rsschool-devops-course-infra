resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ssh" {
  key_name   = "Bastion Host"
  public_key = tls_private_key.ssh.public_key_openssh
}

resource "local_sensitive_file" "pem_file" {
  filename             = pathexpand("~/.ssh/private_key.pem")
  file_permission      = "400"
  directory_permission = "700"
  content              = tls_private_key.ssh.private_key_pem
}