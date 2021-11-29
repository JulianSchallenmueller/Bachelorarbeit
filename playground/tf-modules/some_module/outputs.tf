output "vm_ip_addr" {
  value = google_compute_instance.jsa-module-instance.network_interface[0].access_config[0].nat_ip
}