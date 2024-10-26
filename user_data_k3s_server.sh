#!/bin/bash
curl -sfL https://get.k3s.io | K3S_TOKEN=${token} sh -s -

while [ ! -f /etc/rancher/k3s/k3s.yaml ]; do
    echo "waiting for kubeconfig to be available..."
    sleep 10
done

cp /etc/rancher/k3s/k3s.yaml /home/ec2-user/config.yaml
chmod 666 /home/ec2-user/config.yaml

until kubectl get nodes | grep -q NAME; do
    echo "waiting for the k3s API server to be ready..."
    sleep 10
done

echo "k3s server is up and running."