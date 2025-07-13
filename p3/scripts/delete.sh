#!/bin/bash

# Stop port-forwards if they are still running
echo "Stopping port-forwarding..."

# Replace these with stored PID variables if available
# Otherwise, use `pkill` as a catch-all (careful in shared systems)
pkill -f "kubectl port-forward svc/argocd-server -n argocd"
pkill -f "kubectl port-forward .* -n dev 8888:8888"

# Optionally delete ArgoCD app if still exists
if command -v argocd &> /dev/null; then
  echo "Trying to delete ArgoCD app 'developement' if it exists..."
  argocd login localhost:8443 --username admin --password $(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d) --insecure && \
  argocd app delete developement --yes || echo "App not found or already deleted."
fi

# Delete namespaces
echo "Deleting namespaces 'argocd' and 'dev'..."
kubectl delete namespace argocd --ignore-not-found
kubectl delete namespace dev --ignore-not-found

# Delete k3d cluster
echo "Deleting k3d cluster 'IoT'..."
k3d cluster delete IoT

echo "Cleanup complete."
