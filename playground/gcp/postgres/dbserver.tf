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


locals {
  allowed_ips = ["0.0.0.0/0"]
}

resource "google_sql_database_instance" "pgdatabaseserver1" {
  name             = "jsa-psql06"
  region           = "europe-west3"
  database_version = "POSTGRES_13"
  project = "active-woodland-324808"

  settings {
    # 2 vCores, 7.5GB RAM
    tier = "db-custom-2-7680"

    disk_size         = 10
    disk_type         = "PD_SSD"
    disk_autoresize   = "true"

    backup_configuration {
      backup_retention_settings {
        retained_backups = 7
      }
    }

    ip_configuration {
      require_ssl = "true"
    }
  }

  deletion_protection = "false"
}