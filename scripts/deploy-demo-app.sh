#!/bin/bash
# Deploys the demo application

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

echo "🚀 Deploying Demo Application..."
echo "================================================"

# Apply all manifests
kubectl apply -f "$PROJECT_DIR/apps/demo-app/namespace.yaml"
kubectl apply -f "$PROJECT_DIR/apps/demo-app/configmap.yaml"
kubectl apply -f "$PROJECT_DIR/apps/demo-app/deployment.yaml"
kubectl apply -f "$PROJECT_DIR/apps/demo-app/service.yaml"
kubectl apply -f "$PROJECT_DIR/apps/demo-app/ingress.yaml"

# Wait for deployments
echo "⏳ Waiting for pods to be ready..."
kubectl wait --for=condition=available --timeout=120s deployment/redis -n demo-app
kubectl wait --for=condition=available --timeout=120s deployment/backend -n demo-app
kubectl wait --for=condition=available --timeout=120s deployment/frontend -n demo-app

echo ""
echo "✅ Demo Application deployed successfully!"
echo "================================================"
echo ""
echo "Pods:"
kubectl get pods -n demo-app
echo ""
echo "Services:"
kubectl get svc -n demo-app
echo ""
echo "Access the app:"
echo "  Via Ingress: http://demo.localhost"
echo "  Via port-forward: kubectl port-forward svc/frontend -n demo-app 8081:80"
echo "                    Then visit: http://localhost:8081"

