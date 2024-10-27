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

# create jenkins persistent volume
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: PersistentVolume
metadata:
  name: ${jenkins_pv}
spec:
  accessModes:
  - ReadWriteOnce
  capacity:
    storage: ${jenkins_volume_size}
  csi:
    driver: ebs.csi.aws.com
    volumeHandle: ${jenkins_ebs_id}
EOF

# create jenkins namespace
kubectl create namespace jenkins

# create jenkins persistent volume claim
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: ${jenkins_pvc}
  namespace: jenkins
spec:
  storageClassName: "" # Empty string must be explicitly set otherwise default StorageClass will be set
  volumeName: ${jenkins_pv}
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: ${jenkins_volume_size}
EOF

# create ebs storage class for dynamic persistent volumes provisioning
cat <<EOF | kubectl apply -f -
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: ebs-sc
provisioner: ebs.csi.aws.com
volumeBindingMode: WaitForFirstConsumer
EOF

# install jenkins to k8s with pv dynamically provisioned with default ebs storage class and 
# exposed with NodePort service on node port 30080
helm install jenkins jenkins/jenkins --namespace jenkins --set persistence.existingClaim=${jenkins_pvc} \
  --set controller.serviceType=NodePort --set controller.nodePort=${jenkins_nodeport}

echo "jenkins pod is created."