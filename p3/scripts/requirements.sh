#!/bin/bash

# install k3d
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash


# install argocd cli
curl -sSL -o /tmp/argocd https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
chmod +x /tmp/argocd
sudo mv /tmp/argocd /usr/local/bin/argocd