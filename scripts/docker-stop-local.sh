#!/usr/bin/env bash
set -e

NETWORK="platform-net"

echo "Stopping containers..."

docker stop api web >/dev/null 2>&1 || true

echo "Removing containers..."

docker rm api web >/dev/null 2>&1 || true

echo "Removing network..."

docker network rm "$NETWORK" >/dev/null 2>&1 || true

echo "System stopped."
