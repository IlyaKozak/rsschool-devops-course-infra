Host bastion
  HostName ${bastion_ip}
  User ec2-user
  IdentityFile ${ssh_key_file}
  StrictHostKeyChecking no

Host k3s_server
  HostName ${k3s_server_ip}
  User ec2-user
  IdentityFile ${ssh_key_file}
  ProxyJump bastion
  StrictHostKeyChecking no