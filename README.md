# 🚀 Kubernetes Home Lab

A production-ready Kubernetes home lab setup featuring GitOps with ArgoCD, monitoring with Prometheus/Grafana, and a sample microservices application.

![Kubernetes](https://img.shields.io/badge/kubernetes-%23326ce5.svg?style=for-the-badge&logo=kubernetes&logoColor=white)
![ArgoCD](https://img.shields.io/badge/Argo%20CD-EF7B4D?style=for-the-badge&logo=argo&logoColor=white)
![Prometheus](https://img.shields.io/badge/Prometheus-E6522C?style=for-the-badge&logo=prometheus&logoColor=white)
![Grafana](https://img.shields.io/badge/Grafana-F46800?style=for-the-badge&logo=grafana&logoColor=white)

## 📋 Table of Contents

- [Architecture](#-architecture)
- [Prerequisites](#-prerequisites)
- [Quick Start](#-quick-start)
- [Project Structure](#-project-structure)
- [Components](#-components)
- [Usage](#-usage)
- [Cleanup](#-cleanup)

## 🏗 Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                        Kind Cluster                              │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │                    Ingress (NGINX)                       │    │
│  └─────────────────────────────────────────────────────────┘    │
│           │                    │                    │            │
│  ┌────────▼───────┐  ┌────────▼───────┐  ┌────────▼───────┐    │
│  │    ArgoCD      │  │   Demo App     │  │   Monitoring   │    │
│  │   (GitOps)     │  │  (Frontend +   │  │  (Prometheus   │    │
│  │                │  │   Backend +    │  │   + Grafana)   │    │
│  │                │  │   Database)    │  │                │    │
│  └────────────────┘  └────────────────┘  └────────────────┘    │
│                                                                  │
│  Namespaces: argocd | demo-app | monitoring                     │
└─────────────────────────────────────────────────────────────────┘
```

## 📦 Prerequisites

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) (Running)
- [kubectl](https://kubernetes.io/docs/tasks/tools/) (v1.28+)
- [Kind](https://kind.sigs.k8s.io/docs/user/quick-start/#installation) (v0.20+)
- [Helm](https://helm.sh/docs/intro/install/) (v3.12+)

### Install on macOS:

```bash
# Install Kind (Kubernetes in Docker)
brew install kind

# Install kubectl
brew install kubectl

# Install Helm
brew install helm
```

## 🚀 Quick Start

### 1. Create the Cluster

```bash
# Make scripts executable
chmod +x scripts/*.sh

# Create Kind cluster with ingress support
./scripts/create-cluster.sh
```

### 2. Deploy Everything

```bash
# Deploy all components (ArgoCD, monitoring, demo app)
./scripts/deploy-all.sh
```

### 3. Access Services

| Service | URL | Credentials |
|---------|-----|-------------|
| ArgoCD | https://localhost:8080 | admin / (run `./scripts/get-argocd-password.sh`) |
| Grafana | http://localhost:3000 | admin / admin |
| Demo App | http://localhost:8081 | - |
| Prometheus | http://localhost:9090 | - |

## 📁 Project Structure

```
k8s-homelab/
├── README.md
├── cluster/
│   └── kind-config.yaml        # Kind cluster configuration
├── apps/
│   ├── demo-app/
│   │   ├── namespace.yaml
│   │   ├── deployment.yaml
│   │   ├── service.yaml
│   │   ├── ingress.yaml
│   │   └── configmap.yaml
│   └── monitoring/
│       ├── namespace.yaml
│       └── kube-prometheus-stack-values.yaml
├── argocd/
│   ├── namespace.yaml
│   ├── install.yaml
│   └── applications/
│       ├── demo-app.yaml
│       └── monitoring.yaml
├── scripts/
│   ├── create-cluster.sh
│   ├── deploy-all.sh
│   ├── deploy-argocd.sh
│   ├── deploy-monitoring.sh
│   ├── deploy-demo-app.sh
│   ├── get-argocd-password.sh
│   ├── port-forward.sh
│   └── cleanup.sh
└── docs/
    └── TROUBLESHOOTING.md
```

## 🧩 Components

### 1. Kind Cluster
- Multi-node cluster (1 control-plane + 2 workers)
- Ingress-ready with port mappings
- Local container registry support

### 2. ArgoCD (GitOps)
- Declarative continuous delivery
- Auto-sync with Git repository
- Web UI for visualization

### 3. Demo Application
- **Frontend**: Nginx serving static content
- **Backend**: Python Flask API
- **Database**: Redis for caching
- Health checks and readiness probes

### 4. Monitoring Stack
- **Prometheus**: Metrics collection
- **Grafana**: Visualization dashboards
- **AlertManager**: Alert routing
- Pre-configured Kubernetes dashboards

## 📖 Usage

### Managing with kubectl

```bash
# View all pods
kubectl get pods -A

# Check demo app
kubectl get pods -n demo-app

# View logs
kubectl logs -n demo-app -l app=backend -f

# Scale deployment
kubectl scale deployment backend -n demo-app --replicas=3
```

### Managing with ArgoCD

```bash
# Login to ArgoCD CLI
argocd login localhost:8080

# List applications
argocd app list

# Sync application
argocd app sync demo-app

# Check app health
argocd app get demo-app
```

### Port Forwarding

```bash
# Forward all services
./scripts/port-forward.sh

# Or individually:
kubectl port-forward svc/argocd-server -n argocd 8080:443 &
kubectl port-forward svc/grafana -n monitoring 3000:80 &
kubectl port-forward svc/frontend -n demo-app 8081:80 &
```

## 🧹 Cleanup

```bash
# Delete the entire cluster
./scripts/cleanup.sh

# Or manually:
kind delete cluster --name homelab
```

## 🎯 Learning Goals

By working with this project, you'll learn:

- ✅ Setting up Kubernetes locally with Kind
- ✅ GitOps principles with ArgoCD
- ✅ Kubernetes manifests (Deployments, Services, Ingress)
- ✅ Helm chart deployment
- ✅ Monitoring with Prometheus & Grafana
- ✅ Namespace isolation and RBAC basics
- ✅ Health checks and resource management

## 📚 Next Steps

1. **Add more applications** - Deploy your own apps via ArgoCD
2. **Configure alerts** - Set up AlertManager rules
3. **Add secrets management** - Integrate Sealed Secrets or External Secrets
4. **Enable TLS** - Add cert-manager for certificates
5. **Add service mesh** - Experiment with Istio or Linkerd

## 🤝 Contributing

Feel free to fork and improve this setup!

## 📝 License

MIT License - Use freely for learning and development.

---

**Author:** Mahak Malik  
**LinkedIn:** [linkedin.com/in/malikmahak](https://linkedin.com/in/malikmahak)

