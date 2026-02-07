#!/bin/bash
set -e

echo "Deleting kind cluster..."

# Check if cluster exists
if ! kind get clusters 2>/dev/null | grep -q "^kind$"; then
  echo "No kind cluster found. Nothing to delete."
  exit 0
fi

# Confirm deletion
read -p "Are you sure you want to delete the kind cluster? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  echo "Deletion cancelled."
  exit 0
fi

# Delete the cluster
echo "Deleting cluster..."
kind delete cluster

echo "Kind cluster deleted successfully."
