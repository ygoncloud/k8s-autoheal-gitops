# Variables
IMAGE_NAME = ghcr.io/your-username/k8s-auto-healing
TAG = latest

# Build and push Docker image
build:
	docker build -t $(IMAGE_NAME):$(TAG) .

push:
	docker push $(IMAGE_NAME):$(TAG)

# Run the application locally
deploy-local:
	python src/app.py

# Run tests
test:
	python -m unittest discover src/tests

# Apply Kubernetes manifests
apply-manifests:
	kubectl apply -f manifests/

# Delete Kubernetes resources
delete-manifests:
	kubectl delete -f manifests/

# Connect to the Kubernetes cluster
connect-cluster:
	gcloud container clusters get-credentials gke-cluster --region us-central1
