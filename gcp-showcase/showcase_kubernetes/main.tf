resource "google_container_cluster" "jsa_showcase_gke" {
  name     = "jsa-showcase-cluster"
  location = var.zone

  remove_default_node_pool = true
  initial_node_count       = 1

  network = var.network
}

resource "google_service_account" "node_pool_sa" {
  account_id = "container-sa"
}

resource "google_container_node_pool" "jsa_primary_nodes" {
  name       = "${google_container_cluster.jsa_showcase_gke.name}-node-pool"
  location   = var.zone
  cluster    = google_container_cluster.jsa_showcase_gke.name
  node_count = var.num_nodes

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    service_account = google_service_account.node_pool_sa.email

    machine_type = "e2-micro"
    tags         = ["jsa-gke-node", "jsa-showcase-cluster"]
    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
}