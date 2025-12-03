#!/bin/bash
# Deploys all components to the cluster

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🚀 Deploying All Components..."
echo "================================================"
echo ""

# Deploy ArgoCD
echo "Step 1/3: Deploying ArgoCD..."
"$SCRIPT_DIR/deploy-argocd.sh"
echo ""

# Deploy Monitoring
echo "Step 2/3: Deploying Monitoring Stack..."
"$SCRIPT_DIR/deploy-monitoring.sh"
echo ""

# Deploy Demo App
echo "Step 3/3: Deploying Demo Application..."
"$SCRIPT_DIR/deploy-demo-app.sh"
echo ""

echo "================================================"
echo "🎉 All components deployed successfully!"
echo "================================================"
echo ""
echo "Quick access:"
echo ""
echo "  📊 Grafana:    http://localhost:30001  (admin/admin)"
echo "  📈 Prometheus: http://localhost:30000"
echo "  🔄 ArgoCD:     https://localhost:30002 (admin / run get-argocd-password.sh)"
echo "  🚀 Demo App:   http://demo.localhost"
echo ""
echo "Run ./scripts/port-forward.sh for alternative access"

