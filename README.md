# 🚀 Kubernetes Auto-Healing with GitOps

## Overview
This project implements a **Kubernetes Auto-Healing System** using **GitOps with ArgoCD**, ensuring automatic recovery from failures and maintaining infrastructure stability.

## Features
- ✅ **GitOps Deployment** with ArgoCD  
- ✅ **Auto-Healing** using Kubernetes Liveness & Readiness Probes  
- ✅ **Self-Recovery** with ArgoCD auto-sync  
- ✅ **Monitoring & Alerting** using Prometheus & Grafana  
- ✅ **CI/CD Pipeline** with GitHub Actions  

---

## Tech Stack
- **Kubernetes** (GKE, Minikube, or Kind)
- **ArgoCD** (GitOps)
- **Helm/Kustomize** (Kubernetes manifests management)
- **Prometheus & Grafana** (Monitoring)
- **KEDA** (Auto-scaling based on events)
- **Terraform** (Infrastructure as Code)
- **GitHub Actions** (CI/CD)

---

## Deployment Steps

### Step 1: Set Up Kubernetes Cluster
- **GKE (Google Kubernetes Engine)**
  ```sh
  gcloud container clusters create my-cluster --num-nodes=3
  ```
- **Minikube (Local)**
  ```sh
  minikube start
  ```

### Step 2: Install ArgoCD
```sh
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```
- Access ArgoCD UI:
  ```sh
  kubectl port-forward svc/argocd-server -n argocd 8080:443
  ```
- Login using CLI:
  ```sh
  argocd login localhost:8080
  ```

### Step 3: Deploy Sample Application
- Clone the repository:
  ```sh
  git clone https://github.com/your-username/k8s-auto-healing.git
  cd k8s-auto-healing
  ```
- Apply manifests:
  ```sh
  kubectl apply -f manifests/
  ```

### Step 4: Configure Auto-Healing
Modify the **deployment.yaml**:
```yaml
livenessProbe:
  httpGet:
    path: /health
    port: 8080
  initialDelaySeconds: 3
  periodSeconds: 5

readinessProbe:
  httpGet:
    path: /ready
    port: 8080
  initialDelaySeconds: 3
  periodSeconds: 5
```
Apply the changes:
```sh
kubectl apply -f manifests/deployment.yaml
```

### Step 5: Set Up Monitoring
- Install Prometheus & Grafana:
  ```sh
  helm install prometheus prometheus-community/kube-prometheus-stack -n monitoring
  ```
- Access Grafana UI:
  ```sh
  kubectl port-forward svc/grafana -n monitoring 3000:80
  ```

### Step 6: Configure GitOps Auto-Healing
- Create an ArgoCD App linked to your GitHub repository:
  ```sh
  argocd app create my-app --repo https://github.com/your-username/k8s-auto-healing.git --path manifests --dest-server https://kubernetes.default.svc --dest-namespace default
  ```
- Enable **auto-sync** to ensure Kubernetes always reflects the Git state:
  ```sh
  argocd app set my-app --sync-policy automated
  ```

---

## CI/CD Pipeline
This project includes a **GitHub Actions workflow** for:
- Building & pushing Docker images.
- Updating Kubernetes manifests.
- Triggering ArgoCD sync.

### Workflow File: `.github/workflows/deploy.yaml`
```yaml
name: Deploy to Kubernetes

on:
  push:
    branches:
      - main

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest

    steps:
    - name: Checkout code
      uses: actions/checkout@v2

    - name: Build Docker image
      run: |
        docker build -t ghcr.io/your-username/k8s-auto-healing:latest .
        docker push ghcr.io/your-username/k8s-auto-healing:latest

    - name: Update Kubernetes Manifests
      run: |
        sed -i 's|image:.*|image: ghcr.io/your-username/k8s-auto-healing:latest|' manifests/deployment.yaml
        git commit -am "Updated image to latest version"
        git push

    - name: Sync with ArgoCD
      run: |
        argocd app sync my-app
```

---

## Testing the Auto-Healing Feature
### Test Case 1: Pod Failure
1. Delete a running pod:
   ```sh
   kubectl delete pod <pod-name>
   ```
   ✅ The pod should be **automatically recreated** by Kubernetes.

### Test Case 2: Application Failure
1. Manually introduce an error in the code (e.g., change health check endpoint).
2. Push changes to GitHub.
3. ArgoCD should **auto-revert to the last working state**.

### Test Case 3: Cluster Node Failure
1. Simulate a node failure:
   ```sh
   gcloud compute instances delete <node-name>
   ```
   ✅ Kubernetes should reschedule the pods on a new node.

---

## Cleanup
To delete all resources:
```sh
kubectl delete namespace argocd monitoring
gcloud container clusters delete my-cluster
```

---

## Future Enhancements
- ✅ Implement **Argo Rollouts** for canary deployments  
- ✅ Integrate **KEDA** for event-driven auto-scaling  
- ✅ Use **Istio** for traffic routing and resilience  

---

## Contributing
Feel free to fork, create a feature branch, and submit a pull request! 🤝

---


