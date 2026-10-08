#!/bin/bash

# install docker
sudo apt-get update
sudo apt-get install -y docker.io

# install k3d
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash


#install kubectl
sudo apt-get install -y kubectl
chmod +x kubectl
sudo mv kubectl /usr/local/bin/kubectl


# install argocd cli
curl -sSL -o /tmp/argocd https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
chmod +x /tmp/argocd
sudo mv /tmp/argocd /usr/local/bin/argocd