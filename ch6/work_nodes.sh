#!/usr/bin/env bash

# config for work_nodes only 
sudo kubeadm join --token 123456.1234567890123456 \
             --discovery-token-unsafe-skip-ca-verification 192.168.56.10:6443

echo "***worker node script -- end"