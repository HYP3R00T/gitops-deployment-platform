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
    echo "Example: $0 -s api"
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

echo "Rebuilding service: $SERVICE"
echo ""

# Rebuild based on service
if [[ "$SERVICE" == "api" ]]; then
    echo "→ Building platform-api:latest..."
    docker build -t platform-api:latest -f services/api/Dockerfile services/api/

    echo "→ Loading image into kind..."
    kind load docker-image platform-api:latest

    echo "→ Restarting deployment..."
    kubectl rollout restart deployment/api -n platform-api
    kubectl rollout status deployment/api -n platform-api --timeout=60s
    echo ""
    echo "✓ API Service rebuilt and restarted"

elif [[ "$SERVICE" == "web" ]]; then
    echo "→ Building platform-web:latest..."
    docker build -t platform-web:latest \
        --build-arg PUBLIC_API_URL=http://api.platform-api:8000 \
        -f services/web/Dockerfile services/web/

    echo "→ Loading image into kind..."
    kind load docker-image platform-web:latest

    echo "→ Restarting deployment..."
    kubectl rollout restart deployment/web -n platform-web
    kubectl rollout status deployment/web -n platform-web --timeout=60s
    echo ""
    echo "✓ Web Service rebuilt and restarted"
fi
