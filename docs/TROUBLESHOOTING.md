# Troubleshooting Guide

Common issues and solutions for the K8s Home Lab.

## Cluster Issues

### Kind cluster won't start

**Symptom:** `kind create cluster` fails

**Solutions:**
1. Ensure Docker Desktop is running
2. Check Docker has enough resources (4GB+ RAM recommended)
3. Try deleting existing cluster: `kind delete cluster --name homelab`

### Nodes not ready

**Symptom:** `kubectl get nodes` shows NotReady

**Solutions:**
```bash
# Check node conditions
kubectl describe nodes

# Check system pods
kubectl get pods -n kube-system
```

---

## Ingress Issues

### Ingress controller not working

**Symptom:** Can't access services via localhost

**Solutions:**
1. Check ingress controller is running:
   ```bash
   kubectl get pods -n ingress-nginx
   ```

2. Reinstall ingress controller:
   ```bash
   kubectl delete -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
   kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
   ```

3. Use port-forward as alternative:
   ```bash
   kubectl port-forward svc/frontend -n demo-app 8081:80
   ```

---

## ArgoCD Issues

### Can't login to ArgoCD

**Symptom:** Invalid username/password

**Solutions:**
1. Get the correct password:
   ```bash
   kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
   ```

2. Reset admin password:
   ```bash
   kubectl -n argocd delete secret argocd-initial-admin-secret
   kubectl rollout restart deployment argocd-server -n argocd
   # Get new password after restart
   ```

### ArgoCD sync fails

**Symptom:** Application stuck in "Syncing" or "OutOfSync"

**Solutions:**
1. Check application status:
   ```bash
   kubectl get applications -n argocd
   ```

2. View sync details:
   ```bash
   kubectl describe application demo-app -n argocd
   ```

3. Force sync:
   ```bash
   argocd app sync demo-app --force
   ```

---

## Demo App Issues

### Backend pods crashlooping

**Symptom:** Backend pods in CrashLoopBackOff

**Solutions:**
1. Check logs:
   ```bash
   kubectl logs -n demo-app -l app=backend --tail=50
   ```

2. Check if pip install is failing (network issue):
   ```bash
   kubectl describe pod -n demo-app -l app=backend
   ```

3. Ensure Redis is running first:
   ```bash
   kubectl get pods -n demo-app -l app=redis
   ```

### Frontend shows "Backend unavailable"

**Symptom:** Frontend loads but can't reach backend

**Solutions:**
1. Check backend service:
   ```bash
   kubectl get svc -n demo-app
   kubectl get endpoints backend -n demo-app
   ```

2. Test connectivity:
   ```bash
   kubectl run test --rm -it --image=busybox -- wget -qO- http://backend.demo-app:5000/api/health
   ```

---

## Monitoring Issues

### Grafana not loading

**Symptom:** Can't access Grafana at localhost:30001

**Solutions:**
1. Check Grafana pod:
   ```bash
   kubectl get pods -n monitoring -l app.kubernetes.io/name=grafana
   ```

2. Check service:
   ```bash
   kubectl get svc -n monitoring | grep grafana
   ```

3. Port forward directly:
   ```bash
   kubectl port-forward svc/monitoring-grafana -n monitoring 3000:80
   ```

### Prometheus not scraping targets

**Symptom:** Missing metrics in Prometheus

**Solutions:**
1. Check targets in Prometheus UI (http://localhost:9090/targets)

2. Verify ServiceMonitor:
   ```bash
   kubectl get servicemonitor -A
   ```

3. Check Prometheus config:
   ```bash
   kubectl get secret prometheus-monitoring-kube-prometheus-prometheus -n monitoring -o jsonpath='{.data.prometheus\.yaml\.gz}' | base64 -d | gunzip
   ```

---

## Resource Issues

### Pods stuck in Pending

**Symptom:** Pods won't schedule

**Solutions:**
1. Check events:
   ```bash
   kubectl describe pod <pod-name> -n <namespace>
   ```

2. Check node resources:
   ```bash
   kubectl describe nodes | grep -A5 "Allocated resources"
   ```

3. Increase Docker resources in Docker Desktop settings

### Out of Memory errors

**Symptom:** OOMKilled pods

**Solutions:**
1. Increase container memory limits
2. Reduce replica counts
3. Increase Docker Desktop memory allocation (8GB+ recommended for full stack)

---

## Quick Diagnostics

Run this to get a full status overview:

```bash
echo "=== Nodes ===" && kubectl get nodes
echo "=== All Pods ===" && kubectl get pods -A
echo "=== Services ===" && kubectl get svc -A
echo "=== Ingress ===" && kubectl get ingress -A
echo "=== Recent Events ===" && kubectl get events -A --sort-by='.lastTimestamp' | tail -20
```

---

## Getting Help

1. Check Kind documentation: https://kind.sigs.k8s.io/
2. ArgoCD docs: https://argo-cd.readthedocs.io/
3. Prometheus Operator: https://prometheus-operator.dev/

For cluster logs:
```bash
kind export logs --name homelab ./kind-logs
```

