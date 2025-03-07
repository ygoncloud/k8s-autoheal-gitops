provider "google" {
  project = "your-gcp-project-id"
  region  = "us-central1"
}

resource "google_container_cluster" "primary" {
  name     = "gke-cluster"
  location = "us-central1"

  remove_default_node_pool = true
  initial_node_count       = 1

  node_pool {
    name       = "default-pool"
    node_count = 3

    node_config {
      machine_type = "e2-medium"
      disk_size_gb = 20
      oauth_scopes = [
        "https://www.googleapis.com/auth/cloud-platform"
      ]
    }
  }
}

output "kubernetes_cluster_name" {
  value = google_container_cluster.primary.name
}

