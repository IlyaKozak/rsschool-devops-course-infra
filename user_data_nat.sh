#!/bin/bash
# setup NAT
dnf install iptables-services -y
systemctl enable --now iptables
echo "net.ipv4.ip_forward=1" | tee -a /etc/sysctl.d/custom-ip-forwarding.conf
sysctl -p /etc/sysctl.d/custom-ip-forwarding.conf
/sbin/iptables -t nat -A POSTROUTING -o $(ip -br l | awk '$1 !~ "lo|vir|wl" { print $1}') -j MASQUERADE
/sbin/iptables -F FORWARD
service iptables save
