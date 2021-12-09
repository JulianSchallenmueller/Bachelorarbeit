resource "random_string" "dbPasswordGen" {
  length  = 127
  upper   = true
  lower   = true
  number  = true
  special = true
}

resource "google_sql_user" "admin_user" {
  name     = "dbadmin"
  password = random_string.dbPasswordGen.result
  instance = google_sql_database_instance.pgdatabaseserver1.name
}

resource "google_sql_ssl_cert" "admin_client_cert" {
  common_name = google_sql_user.admin_user.name
  instance    = google_sql_database_instance.pgdatabaseserver1.name
}

resource "google_secret_manager_secret" "pg-database-password-secret" {
  secret_id = "pg-database-password"

  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "pg-database-password" {
  secret = google_secret_manager_secret.pg-database-password-secret.id

  secret_data = random_string.dbPasswordGen.result
}
