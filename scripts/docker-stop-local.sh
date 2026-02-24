#!/usr/bin/env bash
set -e

# Network name from docker-run-local.sh
NETWORK="platform-net"

# Stop and remove all service containers
docker stop api web >/dev/null 2>&1 || true
docker rm api web >/dev/null 2>&1 || true

# Remove shared network
docker network rm "$NETWORK" >/dev/null 2>&1 || true

echo "Services stopped."
