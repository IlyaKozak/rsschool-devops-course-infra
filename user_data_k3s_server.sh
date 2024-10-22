#!/bin/bash
curl -sfL https://get.k3s.io | K3S_TOKEN=${token} sh -s -

until kubectl get nodes | grep -q NAME; do
    echo "waiting for the k3s API server to be ready..."
    sleep 10
done

cp -v /etc/rancher/k3s/k3s.yaml /home/ec2-user/config.yaml
chmod 666 /home/ec2-user/config.yaml

echo "k3s server is up and running."