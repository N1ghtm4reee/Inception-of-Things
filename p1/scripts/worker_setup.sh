#!/bin/bash

MASTER_IP="192.168.56.110"

TOKEN=$(cat /vagrant/token)

sudo apt update
sudo apt install -y curl

curl -sfL https://get.k3s.io | K3S_URL=https://$MASTER_IP:6443 K3S_TOKEN=$TOKEN sh -
