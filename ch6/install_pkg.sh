#!/usr/bin/env bash

# firewall off
sudo ufw disable
# swap off
sudo swapoff -a && sudo sed -i '/swap/s/^/#/' /etc/fstab

# iptable kernel option
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

sudo modprobe br_netfilter 
cat <<EOF | sudo tee /proc/sys/net/ipv4/ip_forward
1
EOF

sudo sysctl -p
