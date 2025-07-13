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

# kubectl port-forward $POD_NAME -n dev 8888:8888 > /dev/null 2>&1 &
POD_NAME=$(kubectl get pods -n "dev" --no-headers | grep "^app" | awk '{print $1}' | head -n 1)

# get secret to access the UI
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d && echo

# setup argocd app
argocd login localhost:8443

argocd app create developement \
  --repo https://github.com/N1ghtm4reee/Inception-of-Things \
  --path p3/confs \
  --dest-server https://kubernetes.default.svc \
  --dest-namespace dev

argocd app sync developement

# expose app port
kubectl port-forward $POD_NAME -n dev 8888:8888 > /dev/null 2>&1 &
kubectl port-forward svc/argocd-server -n argocd 8443:443 > /dev/null 2>&1 &