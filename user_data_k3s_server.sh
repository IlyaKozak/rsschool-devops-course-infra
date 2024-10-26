#!/bin/bash
# install k3s
curl -sfL https://get.k3s.io | K3S_TOKEN=${token} sh -s -
echo "k3s is installed."

# copy k3s kubeconfig file 
mkdir /home/ec2-user/.kube
cp -v /etc/rancher/k3s/k3s.yaml /home/ec2-user/.kube/config
chmod 666 /home/ec2-user/.kube/config

# install helm
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
echo "helm is installed."

# add jenkins repo
helm repo add jenkins https://charts.jenkins.io

# add aws-ebs-csi-driver repo
helm repo add aws-ebs-csi-driver https://kubernetes-sigs.github.io/aws-ebs-csi-driver
helm repo update

until kubectl get nodes | grep -q NAME; do
    echo "waiting for the k3s API server to be ready..."
    sleep 10
done

export KUBECONFIG="/etc/rancher/k3s/k3s.yaml"

# install aws-ebs-csi-driver
helm install aws-ebs-csi-driver --namespace kube-system aws-ebs-csi-driver/aws-ebs-csi-driver

# create ebs storage class and make it default
kubectl patch storageclass local-path -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"false"}}}'
cat <<EOF | kubectl apply -f -
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: ebs-sc
  annotations:
    storageclass.kubernetes.io/is-default-class: "true"
provisioner: ebs.csi.aws.com
volumeBindingMode: WaitForFirstConsumer
EOF

# install jenkins to k8s with pv dynamically provisioned with default ebs storage class
helm install jenkins jenkins/jenkins --namespace jenkins --create-namespace

echo "jenkins pod is created."