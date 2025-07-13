#!/bin/bash

# create cluster
k3d cluster create IoT

# create namespaces
kubectl create namespace argocd
kubectl create namespace dev

# apply deployements to the dedicated namespaces
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# wait for argocd to be ready
echo "Waiting for ArgoCD to be ready..."
kubectl wait --for=condition=available --timeout=300s deployment/argocd-server -n argocd

# start port-forwarding for argocd in background ??
kubectl port-forward svc/argocd-server -n argocd 8443:443 > /dev/null 2>&1 &
ARGOCD_PF_PID=$!

# wait for port-forward to be ready
sleep 5

# get secret to access the UI
ARGOCD_PASSWORD=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
echo "ArgoCD admin password: $ARGOCD_PASSWORD"

# setup argocd app
argocd login localhost:8443 --username admin --password $ARGOCD_PASSWORD --insecure

argocd app create developement \
  --repo https://github.com/N1ghtm4reee/Inception-of-Things \
  --path p3/confs \
  --dest-server https://kubernetes.default.svc \
  --dest-namespace dev

argocd app sync developement

# # # wait for app deployment to be ready
echo "Waiting for app deployment to be ready..."
kubectl wait --for=condition=available --timeout=300s deployment/app -n dev

# # # get pod name after deployment is ready
POD_NAME=$(kubectl get pods -n dev --no-headers | grep "^app" | awk '{print $1}' | head -n 1)

# # # expose app port
kubectl port-forward $POD_NAME -n dev 8888:8888 > /dev/null 2>&1 &
APP_PF_PID=$!

echo "Setup complete!"
echo "ArgoCD UI: https://localhost:8443 (admin/$ARGOCD_PASSWORD)"
echo "App: http://localhost:8888"
echo "Port-forward PIDs: ArgoCD=$ARGOCD_PF_PID, App=$APP_PF_PID"