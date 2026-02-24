#!/bin/bash

set -e

# Default values
SERVICE=""

# Parse command line arguments
while getopts "s:" opt; do
    case $opt in
        s)
            SERVICE="$OPTARG"
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            exit 1
            ;;
        :)
            echo "Option -$OPTARG requires an argument." >&2
            exit 1
            ;;
    esac
done

# Validate service argument
if [[ -z "$SERVICE" ]]; then
    echo "Usage: $0 -s <service>"
    echo ""
    echo "Services:"
    echo "  api    Rebuild and redeploy API service"
    echo "  web    Rebuild and redeploy Web service"
    echo ""
    echo "Example:"
    echo "  $0 -s api"
    echo "  $0 -s web"
    exit 1
fi

if [[ "$SERVICE" != "api" && "$SERVICE" != "web" ]]; then
    echo "❌ Error: Invalid service '$SERVICE'"
    echo "Valid services are: api, web"
    exit 1
fi

# Get the repository root directory (parent of scripts/)
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

# Check if kind cluster exists
if ! kind get clusters 2>/dev/null | grep -q "^kind$"; then
    echo "❌ Error: kind cluster 'kind' does not exist"
    echo "Create it first with: mise kind-up"
    exit 1
fi

# Check if kubectl can connect
if ! kubectl cluster-info &> /dev/null; then
    echo "❌ Error: Cannot connect to kind cluster"
    echo "Verify cluster is running: kind get clusters"
    exit 1
fi

echo "=================================="
echo "KIND Rebuild Service: $SERVICE"
echo "=================================="
echo ""

# Rebuild based on service
if [[ "$SERVICE" == "api" ]]; then
    echo "→ Step 1/3: Building platform-api:latest..."
    docker build -t platform-api:latest -f services/api/Dockerfile services/api/
    echo "  ✓ Image built"
    echo ""

    echo "→ Step 2/3: Loading image into kind cluster..."
    kind load docker-image platform-api:latest
    echo "  ✓ Image loaded"
    echo ""

    echo "→ Step 3/3: Restarting API deployment..."
    kubectl rollout restart deployment/api -n platform-api
    kubectl rollout status deployment/api -n platform-api --timeout=60s
    echo "  ✓ Deployment restarted"
    echo ""

    echo "=================================="
    echo "✓ API Service Rebuilt!"
    echo "=================================="
    echo ""
    echo "Test the API:"
    echo "  kubectl port-forward --address 0.0.0.0 -n platform-api svc/api 8000:8000"
    echo "  curl http://localhost:8000/health"
    echo ""
    echo "View logs:"
    echo "  kubectl logs -n platform-api -l app=api --tail=100 -f"

elif [[ "$SERVICE" == "web" ]]; then
    echo "→ Step 1/3: Building platform-web:latest..."
    docker build -t platform-web:latest \
        --build-arg PUBLIC_API_URL=http://api.platform-api:8000 \
        -f services/web/Dockerfile services/web/
    echo "  ✓ Image built"
    echo ""

    echo "→ Step 2/3: Loading image into kind cluster..."
    kind load docker-image platform-web:latest
    echo "  ✓ Image loaded"
    echo ""

    echo "→ Step 3/3: Restarting Web deployment..."
    kubectl rollout restart deployment/web -n platform-web
    kubectl rollout status deployment/web -n platform-web --timeout=60s
    echo "  ✓ Deployment restarted"
    echo ""

    echo "=================================="
    echo "✓ Web Service Rebuilt!"
    echo "=================================="
    echo ""
    echo "Test the Web service:"
    echo "  kubectl port-forward --address 0.0.0.0 -n platform-web svc/web 4321:4321"
    echo "  curl http://localhost:4321/"
    echo ""
    echo "View logs:"
    echo "  kubectl logs -n platform-web -l app=web --tail=100 -f"
fi
echo ""
