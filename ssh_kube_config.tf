# prepare ssh and k3s configs on local machine for kubectl
resource "local_file" "ssh_kube_config" {
  count = var.is_local_setup ? 1 : 0

  filename = pathexpand("~/.ssh/config")
  content = templatefile("ssh_config.tpl", {
    bastion_ip    = aws_eip.nat.public_ip
    k3s_server_ip = aws_instance.k3s_server.private_ip
    ssh_key_file  = local_sensitive_file.pem_file.filename
  })

  connection {
    type         = "ssh"
    user         = "ec2-user"
    host         = aws_instance.k3s_server.private_ip
    bastion_host = aws_eip.nat.public_ip
    private_key  = local_sensitive_file.pem_file.content
    agent        = true
  }

  # check if k3s config is ready for download
  provisioner "remote-exec" {
    on_failure = fail
    inline = [
      "while [ ! -f /home/ec2-user/config.yaml ]; do echo 'waiting for k3s kubeconfig file to be ready...'; sleep 10; done"
    ]
  }

  # scp k3s config from k3s server to local machine
  provisioner "local-exec" {
    on_failure  = continue
    command     = "scp k3s_server:/home/ec2-user/config.yaml config"
    interpreter = ["bash", "-c"]
  }

  # update k3s config for kubectl
  provisioner "local-exec" {
    on_failure  = continue
    command     = "sed -i s/127.0.0.1/${aws_instance.k3s_server.private_ip}/ config; sed -i '6i \\ \\ \\ \\ proxy-url: socks5://localhost:1080' config"
    interpreter = ["bash", "-c"]
  }

  # move k3s config to ~/.kube folder
  provisioner "local-exec" {
    on_failure  = continue
    command     = "mv config ~/.kube/config; chmod 600 ~/.kube/config"
    interpreter = ["bash", "-c"]
  }
}