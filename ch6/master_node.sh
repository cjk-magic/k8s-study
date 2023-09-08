#!/usr/bin/env bash

# init kubernetes 
sudo kubeadm init --token 123456.1234567890123456 --token-ttl 0 \
--pod-network-cidr=172.16.0.0/16 --apiserver-advertise-address=192.168.56.10 

# config for master node only 
mkdir -p /home/vagrant/.kube

sudo cp -i /etc/kubernetes/admin.conf /home/vagrant/.kube/config
sudo chown  vagrant:vagrant /home/vagrant/.kube/config

# config for kubernetes's network 
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"

