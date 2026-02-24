#!/usr/bin/env bash
set -e

# Docker network for inter-service communication
NETWORK="platform-net"
API_IMAGE="platform-api:latest"
WEB_IMAGE="platform-web:latest"

# Build Docker images from service Dockerfiles
echo "Building images..."

docker build -t "$API_IMAGE" ./services/api
docker build -t "$WEB_IMAGE" ./services/web

# Create shared network for service communication (idempotent)
echo "Creating network..."

docker network inspect "$NETWORK" >/dev/null 2>&1 || \
  docker network create "$NETWORK"

# Clean up any existing containers to avoid port conflicts
echo "Cleaning up..."

docker rm -f api web >/dev/null 2>&1 || true

# Start API and Web services on shared network
echo "Starting API..."

docker run -d \
  --name api \
  --network "$NETWORK" \
  -p 8000:8000 \
  "$API_IMAGE"

echo "Starting Web..."
docker run -d \
  --name web \
  --network "$NETWORK" \
  -p 4321:4321 \
  "$WEB_IMAGE"

echo
echo "Services ready:"
echo "API: http://localhost:8000"
echo "Web: http://localhost:4321"
