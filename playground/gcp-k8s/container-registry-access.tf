data "google_storage_bucket" "container_registry_storage_bucket" {
  name = "eu.artifacts.${var.project}.appspot.com"
}

resource "google_storage_bucket_iam_member" "viewer" {
  bucket = data.google_storage_bucket.container_registry_storage_bucket.name
  role = "roles/storage.objectViewer"
  member = "serviceAccount:${google_service_account.node_pool_sa.email}"
}