terraform {
  # backend "gcs" {
  #   bucket = "jsa-terraformstate"
  # }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.1.0"
    }
  }

  required_version = ">=1.0.11"
}

resource "google_container_cluster" "primary" {
  name               = "test"
  location           = "europe-west3-b"
  project = "active-woodland-324808"

  initial_node_count = 2

  node_config {
    # 2vCPU, 8 GB RAM
    machine_type = "e2-standard-2"
    disk_size_gb = 100
    disk_type = "pd-ssd"
  }
}