#!/bin/bash

# Set variables
IMAGE_NAME="ghcr.io/your-username/k8s-auto-healing"
TAG="latest"

# Build and push Docker image
echo "Building Docker image..."
docker build -t $IMAGE_NAME:$TAG .

echo "Pushing Docker image to registry..."
docker push $IMAGE_NAME:$TAG

# Apply Kubernetes manifests
echo "Applying Kubernetes manifests..."
kubectl apply -f manifests/

# Ensure ArgoCD sync
echo "Syncing ArgoCD application..."
kubectl apply -f manifests/argocd-app.yaml -n argocd
argocd app sync k8s-auto-healing

echo "Deployment complete."
