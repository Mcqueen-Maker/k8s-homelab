#!/bin/bash
# Deploys ArgoCD to the cluster

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

echo "🔄 Deploying ArgoCD..."
echo "================================================"

# Create namespace
kubectl apply -f "$PROJECT_DIR/argocd/namespace.yaml"

# Install ArgoCD
echo "📦 Installing ArgoCD..."
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Wait for ArgoCD to be ready
echo "⏳ Waiting for ArgoCD to be ready..."
kubectl wait --for=condition=available --timeout=300s deployment/argocd-server -n argocd

# Patch ArgoCD server to disable TLS (for local dev)
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "NodePort", "ports": [{"port": 443, "targetPort": 8080, "nodePort": 30002}]}}'

# Get initial admin password
ARGOCD_PASSWORD=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)

echo ""
echo "✅ ArgoCD deployed successfully!"
echo "================================================"
echo ""
echo "Access ArgoCD UI:"
echo "  URL: https://localhost:30002"
echo "  Username: admin"
echo "  Password: $ARGOCD_PASSWORD"
echo ""
echo "Or port-forward:"
echo "  kubectl port-forward svc/argocd-server -n argocd 8080:443"
echo "  Then visit: https://localhost:8080"
echo ""
echo "To deploy applications via ArgoCD:"
echo "  kubectl apply -f $PROJECT_DIR/argocd/applications/"

