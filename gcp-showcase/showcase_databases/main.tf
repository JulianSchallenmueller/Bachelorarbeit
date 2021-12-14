locals {
  allowed_ips = ["0.0.0.0/0"]
}

resource "google_sql_database_instance" "pgdatabaseserver1" {
  name             = "jsa-${var.environment}-psql1"
  region           = var.region
  database_version = "POSTGRES_13"
  settings {
    tier = "db-f1-micro"

    availability_type = "ZONAL"
    disk_size         = 10
    disk_type         = "PD_HDD"
    disk_autoresize   = "true"

    backup_configuration {
      backup_retention_settings {
        retained_backups = 7
      }
    }

    ip_configuration {
      ipv4_enabled = "true"

      require_ssl = "true"

      dynamic "authorized_networks" {
        for_each = local.allowed_ips
        iterator = allowed_ips

        content {
          value = allowed_ips.value
        }
      }
    }
  }

  deletion_protection = "false"
}

resource "google_sql_database" "orderdomain_db" {
  name     = "orderdomain"
  instance = google_sql_database_instance.pgdatabaseserver1.name
}

resource "google_sql_database" "manufacturerdomain_db" {
  name     = "manufacturerdomain"
  instance = google_sql_database_instance.pgdatabaseserver1.name
}

resource "google_sql_database" "supplierdomain_db" {
  name     = "supplierdomain"
  instance = google_sql_database_instance.pgdatabaseserver1.name
}

