data "google_client_config" "default" {}

provider "kubernetes" {
  host = "https://${google_container_cluster.jsa_cluster.endpoint}"

  token = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(google_container_cluster.jsa_cluster.master_auth[0].cluster_ca_certificate)
}

resource "kubernetes_deployment" "jsa_testapp" {
  metadata {
    name = "jsa-testapp"
    labels = {
      App = "jsa-testapp"
    }
  }

  spec {
    replicas = 2
    selector {
      match_labels = {
        App = "jsa-testapp"
      }
    }

    template {
      metadata {
        labels = {
          App = "jsa-testapp"
        }
      }
      spec {
        container {
          image = "eu.gcr.io/active-woodland-324808/testapp:latest"
          name = "jsa-testapp"

          port {
            container_port = 8080
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "jsa_testapp_lb" {
  metadata {
    name =  "jsa-testapp-example"
  }

  spec {
    selector = {
      App = kubernetes_deployment.jsa_testapp.spec.0.template.0.metadata[0].labels.App
    }
    port {
      port = 8081
      target_port = 8080
    }

    type = "LoadBalancer"
  }
}