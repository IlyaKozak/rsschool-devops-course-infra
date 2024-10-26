#!/bin/bash
curl -sfL https://get.k3s.io | K3S_TOKEN=${token} sh -s -

cp -v /etc/rancher/k3s/k3s.yaml /home/ec2-user/config.yaml
chmod 666 /home/ec2-user/config.yaml

echo "k3s is installed."

# install helm
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

echo "helm is installed."

# add jenkins repo
helm repo add jenkins https://charts.jenkins.io
helm repo update

until kubectl get nodes | grep -q NAME; do
    echo "waiting for the k3s API server to be ready..."
    sleep 10
done

# install jenkins to k8s
helm install jenkins jenkins/jenkins --namespace jenkins --create-namespace  --kubeconfig /etc/rancher/k3s/k3s.yaml

echo "jenkins pod is created."