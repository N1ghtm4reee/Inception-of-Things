#!/bin/bash

MASTER_IP="192.168.56.110"

# Get the token from the shared folder
TOKEN=$(cat /vagrant/token)

# Install K3s agent (worker) and join the master node
curl -sfL https://get.k3s.io | K3S_URL=https://$MASTER_IP:6443 K3S_TOKEN=$TOKEN sh -


# sudo snap install kubelet --classic
# sudo snap install kubeadm --classic