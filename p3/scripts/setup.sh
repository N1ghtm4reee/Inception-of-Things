#!/bin/bash

# install k3d
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

# create cluster
k3d cluster create IoT

# create namespaces
sudo kubectl create namespace argocd
sudo kubectl create namespace dev

# apply deployements to the dedicated namespaces
sudo kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# expose port to access the argoCD UI
kubectl port-forward svc/argocd-server -n argocd 8443:443 > /dev/null 2>&1 &

# get secret to access the UI
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d && echo




