#!/usr/bin/env bash
set -e

NETWORK="platform-net"
API_IMAGE="platform-api:latest"
WEB_IMAGE="platform-web:latest"

echo "Building images..."

docker build -t "$API_IMAGE" ./services/api
docker build -t "$WEB_IMAGE" ./services/web

echo "Creating network (if not exists)..."

docker network inspect "$NETWORK" >/dev/null 2>&1 || \
  docker network create "$NETWORK"

echo "Stopping old containers..."

docker rm -f api web >/dev/null 2>&1 || true

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
echo "System running:"
echo "API: http://localhost:8000"
echo "Web: http://localhost:4321"
