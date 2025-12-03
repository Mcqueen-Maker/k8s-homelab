#!/bin/bash
# Creates a Kind cluster for the homelab

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

CLUSTER_NAME="homelab"
CONFIG_FILE="$PROJECT_DIR/cluster/kind-config.yaml"

echo "🚀 Creating Kind cluster: $CLUSTER_NAME"
echo "================================================"

# Check if cluster already exists
if kind get clusters 2>/dev/null | grep -q "^${CLUSTER_NAME}$"; then
    echo "⚠️  Cluster '$CLUSTER_NAME' already exists."
    read -p "Delete and recreate? (y/N): " confirm
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        kind delete cluster --name "$CLUSTER_NAME"
    else
        echo "Keeping existing cluster."
        exit 0
    fi
fi

# Create cluster
echo "📦 Creating cluster with config: $CONFIG_FILE"
kind create cluster --config "$CONFIG_FILE"

# Wait for cluster to be ready
echo "⏳ Waiting for cluster to be ready..."
kubectl wait --for=condition=Ready nodes --all --timeout=120s

# Install NGINX Ingress Controller
echo "🌐 Installing NGINX Ingress Controller..."
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml

# Wait for ingress to be ready
echo "⏳ Waiting for Ingress Controller..."
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=120s

echo ""
echo "✅ Cluster '$CLUSTER_NAME' is ready!"
echo "================================================"
echo ""
echo "Cluster info:"
kubectl cluster-info --context kind-$CLUSTER_NAME
echo ""
echo "Nodes:"
kubectl get nodes
echo ""
echo "Next steps:"
echo "  1. Run ./scripts/deploy-all.sh to deploy all components"
echo "  2. Or deploy individually:"
echo "     - ./scripts/deploy-argocd.sh"
echo "     - ./scripts/deploy-monitoring.sh"
echo "     - ./scripts/deploy-demo-app.sh"

