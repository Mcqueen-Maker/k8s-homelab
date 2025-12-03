#!/bin/bash
# Port forwards all services for local access

echo "🔌 Starting port forwards..."
echo "================================================"
echo ""
echo "Services will be available at:"
echo "  ArgoCD:     https://localhost:8080"
echo "  Grafana:    http://localhost:3000"
echo "  Prometheus: http://localhost:9090"
echo "  Demo App:   http://localhost:8081"
echo ""
echo "Press Ctrl+C to stop all port forwards"
echo ""

# Kill any existing port-forwards
pkill -f "kubectl port-forward" 2>/dev/null || true

# Start port forwards in background
kubectl port-forward svc/argocd-server -n argocd 8080:443 &
kubectl port-forward svc/monitoring-grafana -n monitoring 3000:80 &
kubectl port-forward svc/monitoring-kube-prometheus-prometheus -n monitoring 9090:9090 &
kubectl port-forward svc/frontend -n demo-app 8081:80 &

# Wait for user interrupt
wait

