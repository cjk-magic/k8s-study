#!/usr/bin/env bash

# Install Kubernetes Servers
sudo apt update
sudo apt -y install curl apt-transport-https
curl  -fsSL  https://packages.cloud.google.com/apt/doc/apt-key.gpg|sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/kubernetes.gpg
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt update
sudo apt -y install vim git curl wget kubelet kubeadm kubectl containerd
sudo apt-mark hold kubelet kubeadm kubectl

sudo systemctl enable containerd
sudo systemctl enable kubelet

sudo modprobe br_netfilter 
cat <<EOF | sudo tee /proc/sys/net/ipv4/ip_forward
1
EOF

