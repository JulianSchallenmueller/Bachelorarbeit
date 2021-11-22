terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.1.0"
    }
  }

  backend "gcs" {
    bucket = "tf-state"
    prefix = "terraform/state"
  }
}

provider "google" {
  credentials = file("/home/julian/Documents/gcp/active-woodland-324808-271662d37497.json")

  project = "active-woodland-324808"
  region = "europe-west3"
  zone = "europe-west3-b"
}

resource "google_compute_network" "vpc_network" {
  name = "vm-network"
  auto_create_subnetworks = true
}

resource "google_compute_instance" "vm" {
  name = "vm-instance"
  machine_type = "f1-micro"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-minimal-2004-lts"
    }
  }

  network_interface {
    network = google_compute_network.vpc_network.name
    access_config {
    }
  }
}