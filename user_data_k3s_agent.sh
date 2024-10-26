#!/bin/bash
curl -sfL https://get.k3s.io | K3S_URL="https://${k3s_server_private_ip}:6443" K3S_TOKEN=${token} sh -s -