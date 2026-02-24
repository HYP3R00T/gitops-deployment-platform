#!/bin/bash

set -e

echo "Starting full deployment workflow..."
echo ""

# Get the repository root directory (parent of scripts/)
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

# Check if kind is installed
if ! command -v kind &> /dev/null; then
    echo "❌ Error: 'kind' is not installed or not in PATH"
    echo "Please install kind: https://kind.sigs.k8s.io/docs/user/quick-start/#installation"
    exit 1
fi

# Check if kubectl is installed
if ! command -v kubectl &> /dev/null; then
    echo "❌ Error: 'kubectl' is not installed or not in PATH"
    echo "Please install kubectl: https://kubernetes.io/docs/tasks/tools/"
    exit 1
fi

# Check if docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Error: 'docker' is not installed or not in PATH"
    exit 1
fi

# Step 1: Ensure kind cluster exists
echo "→ Step 1/6: Checking kind cluster..."
if kind get clusters 2>/dev/null | grep -q "^kind$"; then
    echo "  ✓ Cluster exists"
else
    echo "  Creating cluster..."
    bash "$REPO_ROOT/scripts/create-kind-cluster.sh"
fi

# Step 2: Build Docker images
echo "→ Step 2/6: Building Docker images..."
docker build -t platform-api:latest -f services/api/Dockerfile services/api/
docker build -t platform-web:latest \
    --build-arg PUBLIC_API_URL=http://api.platform-api:8000 \
    -f services/web/Dockerfile services/web/
echo "  ✓ Images built"

# Step 3: Load images into kind
echo "→ Step 3/6: Loading images into kind cluster..."
kind load docker-image platform-api:latest
kind load docker-image platform-web:latest
echo "  ✓ Images loaded"

# Step 4: Deploy manifests
echo "→ Step 4/6: Deploying manifests..."
kubectl apply -k gitops/apps/local/
echo "  ✓ Manifests applied"

# Step 5: Wait for pods to be ready
echo "→ Step 5/6: Waiting for pods to be ready..."
kubectl wait --for=condition=ready pod -l app=api -n platform-api --timeout=120s || {
    echo "  ⚠ API pods did not become ready in time"
    echo "  Check pod status with: kubectl get pods -n platform-api"
}

kubectl wait --for=condition=ready pod -l app=web -n platform-web --timeout=120s || {
    echo "  ⚠ Web pods did not become ready in time"
    echo "  Check pod status with: kubectl get pods -n platform-web"
}
echo "  ✓ Pods ready"

# Step 6: Display status and access instructions
echo "→ Step 6/6: Deployment Complete!"
echo ""
echo "API Service:"
kubectl get pods -n platform-api
echo ""
echo "Web Service:"
kubectl get pods -n platform-web
echo ""
echo "Use port-forwarding to access services:"
echo "  API:  kubectl port-forward --address 0.0.0.0 -n platform-api svc/api 8000:8000"
echo "  Web:  kubectl port-forward --address 0.0.0.0 -n platform-web svc/web 4321:4321"
