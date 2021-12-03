data "google_container_registry_image" "container_image" {
  name = "testapp"
  digest = "d20f6cf11b85b79867c3b5f491a97af25eab8106af4b275333bd02d6b4d035be"
}