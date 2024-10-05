#!/usr/bin/bash
sudo dnf install iptables-services -y
sudo systemctl enable iptables
sudo systemctl start iptables
echo "net.ipv4.ip_forward=1" | sudo tee -a /etc/sysctl.d/custom-ip-forwarding.conf
sudo sysctl -p /etc/sysctl.d/custom-ip-forwarding.conf
sudo /sbin/iptables -t nat -A POSTROUTING -o $(ip -br l | awk '$1 !~ "lo|vir|wl" { print $1}') -j MASQUERADE
sudo /sbin/iptables -F FORWARD
sudo service iptables save