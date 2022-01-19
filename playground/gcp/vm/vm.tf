terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.1.0"
    }
  }

  # backend "gcs" {
  #   bucket = "jsa-tf-state"
  # }
}

provider "google" {
  project = "active-woodland-324808"
  region  = "europe-west3"
  zone    = "europe-west3-b"
}

resource "google_compute_network" "vpc_network" {
  name                    = "vm-network"
  auto_create_subnetworks = true
}


resource "google_compute_firewall" "vm_firewall" {
  name = "vm-firewall"

  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_instance" "vm" {
  name         = "vm-instance"
  machine_type = "e2-micro"

  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
      type = "pd-ssd"
      size = 40
    }
  }

  network_interface {
    network = google_compute_network.vpc_network.name
    access_config {
    }
  }
}