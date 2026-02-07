#!/bin/bash
set -e

echo "Creating kind cluster with deterministic networking..."

# Path to the kind configuration file
KIND_CONFIG="./local/kubernetes/kind.yaml"

# Check if kind config exists
if [ ! -f "$KIND_CONFIG" ]; then
  echo "Error: kind configuration not found at $KIND_CONFIG"
  exit 1
fi

# Check if cluster already exists
if kind get clusters 2>/dev/null | grep -q "^kind$"; then
  echo "A kind cluster already exists."
  read -p "Do you want to delete and recreate it? (y/N): " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo " Deleting existing cluster..."
    kind delete cluster
  else
    echo " Keeping existing cluster. Exiting."
    exit 0
  fi
fi

# Create the cluster with fixed port (6443)
echo "Creating cluster with configuration from $KIND_CONFIG..."
kind create cluster --config "$KIND_CONFIG"

# Patch kubeconfig to use Docker Gateway and TLS override
echo "Patching kubeconfig for devcontainer networking..."
kubectl config set-cluster kind-kind \
  --server=https://host.docker.internal:6443 \
  --tls-server-name=localhost

# Verify the connection
echo "Verifying cluster connectivity..."
if kubectl get nodes >/dev/null 2>&1; then
  echo "Success! Cluster is ready."
  kubectl get nodes
else
  echo "Failed to connect to cluster. Check your configuration."
  exit 1
fi

echo "You can now use kubectl to interact with your cluster."
echo "Example: kubectl get pods --all-namespaces"
