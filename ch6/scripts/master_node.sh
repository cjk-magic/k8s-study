#!/bin/sh

# init kubernetes 
kubeadm init > kubeadm-init.log

# config for master node only 
mkdir -p /root/.kube

sudo cp -i /etc/kubernetes/admin.conf /root/.kube/config

# config for kubernetes's network 
kubectl apply -f https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s.yaml
