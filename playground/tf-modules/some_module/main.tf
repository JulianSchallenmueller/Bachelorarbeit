resource "google_compute_instance" "jsa-module-instance" {
  name = var.vm_name

  machine_type = "f1-micro"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-minimal-2004-lts"
    }
  }

  network_interface {
    subnetwork = var.network
    access_config {
    }
  }
}