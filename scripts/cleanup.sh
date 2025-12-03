#!/bin/bash
# Cleans up the Kind cluster

CLUSTER_NAME="homelab"

echo "🧹 Cleaning up..."
echo "================================================"

# Kill any port forwards
echo "Stopping port forwards..."
pkill -f "kubectl port-forward" 2>/dev/null || true

# Delete the cluster
echo "Deleting Kind cluster: $CLUSTER_NAME"
kind delete cluster --name "$CLUSTER_NAME"

echo ""
echo "✅ Cleanup complete!"
echo ""
echo "To recreate the cluster, run:"
echo "  ./scripts/create-cluster.sh"

