output "postgres_server_ipv4" {
  value = google_sql_database_instance.pgdatabaseserver.ip_address.0.ip_address
}

output "admin_private_key" {
  value = google_sql_ssl_cert.admin_client_cert.private_key
  sensitive = true
}

output "admin_cert" {
  value = google_sql_ssl_cert.admin_client_cert.cert
}

output "ca-cert" {
  value = google_sql_ssl_cert.admin_client_cert.server_ca_cert
}