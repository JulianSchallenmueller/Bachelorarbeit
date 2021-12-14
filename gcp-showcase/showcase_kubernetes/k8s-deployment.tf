provider "kubernetes" {
  host = "https://${google_container_cluster.jsa_showcase_gke.endpoint}"

  token = data.google_client_config.default.access_token

  cluster_ca_certificate = base64decode(google_container_cluster.jsa_showcase_gke.master_auth[0].cluster_ca_certificate)
  client_certificate     = base64decode(google_container_cluster.jsa_showcase_gke.master_auth[0].client_certificate)
  client_key             = base64decode(google_container_cluster.jsa_showcase_gke.master_auth[0].client_key)
}

# resource "kubernetes_namespace" "orderdomainNamespace" {
#   metadata {
#     name = "orderdomain"
#   }
# }

# resource "kubernetes_namespace" "supplierdomainNamespace" {
#   metadata {
#     name = "supplierdomain"
#   }
# }

# resource "kubernetes_namespace" "manufacturedomainNamespace" {
#   metadata {
#     name = "manufacturedomain"
#   }
# }

# resource "kubernetes_namespace" "integrationdomainNamespace" {
#   metadata {
#     name = "integrationdomain"
#   }
# }

data "google_client_config" "default" {}

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
          name  = "jsa-testapp"

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
    name = "jsa-showcase-testapp"
  }

  spec {
    selector = {
      App = kubernetes_deployment.jsa_testapp.spec.0.template.0.metadata[0].labels.App
    }
    port {
      port        = 8081
      target_port = 8080
    }

    type = "LoadBalancer"
  }
}