output "postgres_server_ipv4" {
  value = module.showcase_databases.postgres_server_ipv4
}

output "cluster_endpoint" {
  value = module.showcase_kubernetes.cluster_endpoint
}