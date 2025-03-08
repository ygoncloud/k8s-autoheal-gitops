#!/bin/bash

# Delete Kubernetes resources
kubectl delete -f manifests/

# Delete ArgoCD application
kubectl delete -f manifests/argocd-app.yaml -n argocd

# Delete Prometheus and Grafana
kubectl delete -f manifests/prometheus.yaml
kubectl delete -f manifests/grafana.yaml

# Delete Horizontal Pod Autoscaler (HPA) and KEDA
kubectl delete -f manifests/hpa.yaml
kubectl delete -f manifests/keda.yaml

# Delete the Kubernetes cluster (if using GKE)
read -p "Do you want to delete the GKE cluster? (y/n): " CONFIRM
if [ "$CONFIRM" == "y" ]; then
    gcloud container clusters delete gke-cluster --region us-central1 --quiet
    echo "GKE cluster deleted."
else
    echo "Skipping cluster deletion."
fi

echo "Cleanup complete."

