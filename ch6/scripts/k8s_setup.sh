#!/bin/sh

# Install Kubernetes Servers
apt update
apt -y install curl apt-transport-https
curl  -fsSL  https://packages.cloud.google.com/apt/doc/apt-key.gpg| gpg --dearmor -o /etc/apt/trusted.gpg.d/kubernetes.gpg
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" |  tee /etc/apt/sources.list.d/kubernetes.list

apt update
apt -y install vim git curl wget kubelet kubeadm kubectl containerd
apt-mark hold kubelet kubeadm kubectl

systemctl enable containerd
systemctl enable kubelet

modprobe br_netfilter 
cat <<EOF | sudo tee /proc/sys/net/ipv4/ip_forward
1
EOF

