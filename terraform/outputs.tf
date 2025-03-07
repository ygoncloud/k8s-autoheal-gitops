output "kubernetes_cluster_name" {
  description = "The name of the GKE cluster"
  value       = google_container_cluster.primary.name
}

output "kubernetes_cluster_endpoint" {
  description = "The endpoint for the GKE cluster"
  value       = google_container_cluster.primary.endpoint
}

output "kubernetes_cluster_region" {
  description = "The region where the GKE cluster is deployed"
  value       = var.region
}

output "gke_credentials_command" {
  description = "Command to authenticate kubectl with the cluster"
  value       = "gcloud container clusters get-credentials ${google_container_cluster.primary.name} --region ${var.region}"
}

