terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.90.01"
    }
  }
}

provider "google" {
  project = "active-woodland-324808"
  region  = "europe-west3"
  zone    = "europe-west3-b"
}

module "network" {
  source       = "terraform-google-modules/network/google"
  version      = "4.0.1"
  network_name = "jsa-tf-network"
  project_id   = "active-woodland-324808"
  subnets = [
    {
      subnet_name   = "jsa-tf-subnet"
      subnet_ip     = "10.10.10.0/24"
      subnet_region = "europe-west3"
    }
  ]
}

resource "google_compute_firewall" "jsa_vm_firewall" {
  name = "jsa-terraform-firewall"

  network = module.network.network_name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}

variable "vm_name" {}

module "some_module" {
  source = "./some_module"

  vm_name = var.vm_name
  network = module.network.subnets_self_links[0]
}

output "some_module_output" {
  value = module.some_module.vm_ip_addr
}

resource "google_compute_instance" "vm" {
  name         = "vm-instance"
  machine_type = "f1-micro"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-minimal-2004-lts"
    }
  }

  network_interface {
    subnetwork = module.network.subnets_self_links[0]
  }
}
