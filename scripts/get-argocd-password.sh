#!/bin/bash
# Gets the ArgoCD admin password

echo "ArgoCD Admin Password:"
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
echo ""

