#!/bin/bash
# Deploys Prometheus and Grafana monitoring stack

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

echo "📊 Deploying Monitoring Stack..."
echo "================================================"

# Create namespace
kubectl apply -f "$PROJECT_DIR/apps/monitoring/namespace.yaml"

# Add Helm repo
echo "📦 Adding Prometheus Helm repository..."
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

# Install kube-prometheus-stack
echo "🚀 Installing kube-prometheus-stack..."
helm upgrade --install monitoring prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --values "$PROJECT_DIR/apps/monitoring/kube-prometheus-stack-values.yaml" \
  --wait \
  --timeout 10m

echo ""
echo "✅ Monitoring Stack deployed successfully!"
echo "================================================"
echo ""
echo "Access services:"
echo ""
echo "  Grafana:"
echo "    URL: http://localhost:30001"
echo "    Username: admin"
echo "    Password: admin"
echo ""
echo "  Prometheus:"
echo "    URL: http://localhost:30000"
echo ""
echo "Or port-forward:"
echo "  kubectl port-forward svc/monitoring-grafana -n monitoring 3000:80"
echo "  kubectl port-forward svc/monitoring-kube-prometheus-prometheus -n monitoring 9090:9090"

