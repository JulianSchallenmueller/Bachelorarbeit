terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.2.1"
    }
  }
}

provider "google" {
  project = var.project
  region = var.region
  zone = var.zone
}

resource "google_service_account" "node_pool_sa" {
  account_id = "node-pool-sa"
}

resource "google_container_cluster" "jsa_cluster" {
  name = "jsa-cluster"
  location = var.zone

  remove_default_node_pool = true
  initial_node_count = 1
}

resource "google_container_node_pool" "jsa_node_pool" {
  name = "jsa-node-pool"
  location = var.zone

  cluster = google_container_cluster.jsa_cluster.name
  node_count = 2

  node_config {
    preemptible  = true
    machine_type = "e2-micro"

    service_account = google_service_account.node_pool_sa.email
    oauth_scopes    = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}