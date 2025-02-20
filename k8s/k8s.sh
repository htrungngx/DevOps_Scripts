#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

USERNAME="devops"
PASSWORD="devops"

# Define host entries
# Change host ip address and its name
HOSTS=(
#"34.78.101.70 k8s-master"
#"34.78.244.120 k8s-node1"
#"34.34.180.12 k8s-node2"
#"34.76.138.19 k8s-node3"
)

echo "Updating and upgrading system packages..."
sudo apt update -y && sudo apt upgrade -y


echo "Disabling swap..."
sudo swapoff -a
sudo sed -i '/swap.img/s/^/#/' /etc/fstab

echo "Configuring kernel modules..."
echo -e "overlay\nbr_netfilter" | sudo tee /etc/modules-load.d/containerd.conf > /dev/null
sudo modprobe overlay
sudo modprobe br_netfilter

echo "Configuring networking settings for Kubernetes..."
cat <<EOL | sudo tee /etc/sysctl.d/kubernetes.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOL
sudo sysctl --system

echo "Adding host entries to /etc/hosts..."
for HOST in "${HOSTS[@]}"; do
    if ! grep -q "$HOST" /etc/hosts; then
        echo "$HOST" | sudo tee -a /etc/hosts > /dev/null
    else
        echo "$HOST already exists in /etc/hosts."
    fi
done

echo "Installing Docker and dependencies..."
sudo apt install -y curl gnupg2 software-properties-common apt-transport-https ca-certificates
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmour -o /etc/apt/trusted.gpg.d/docker.gpg
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

sudo apt update -y
sudo apt install -y containerd.io

echo "Configuring containerd..."
sudo containerd config default | sudo tee /etc/containerd/config.toml >/dev/null
sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/g' /etc/containerd/config.toml
sudo systemctl restart containerd
sudo systemctl enable containerd

echo "Installing Kubernetes package repositories..."
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.31/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.31/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

echo "Installing Kubernetes (kubelet, kubeadm, kubectl)..."
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl

echo "Locking Kubernetes package versions to prevent unexpected upgrades..."
sudo apt-mark hold kubelet kubeadm kubectl

echo "Setup completed under user '$USERNAME'."
