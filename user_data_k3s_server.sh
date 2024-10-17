#!/bin/bash
curl -sfL https://get.k3s.io | K3S_TOKEN=${token} sh -s -

while [ ! -f /etc/rancher/k3s/k3s.yaml ]; do
    echo "Waiting for kubeconfig to be available..."
    sleep 10
done

until kubectl get nodes; do
    echo "Waiting for the K3s API server to be ready..."
    sleep 10
done

echo "K3s server is up and running."