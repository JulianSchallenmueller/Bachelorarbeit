provider "kubernetes" {
  host                   = azurerm_kubernetes_cluster.jsa_k8s.kube_config.0.host
  client_certificate     = base64decode(azurerm_kubernetes_cluster.jsa_k8s.kube_config.0.client_certificate)
  client_key             = base64decode(azurerm_kubernetes_cluster.jsa_k8s.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.jsa_k8s.kube_config.0.cluster_ca_certificate)
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
          image = "jsacontainerregistry.azurecr.io/testapp:latest"
          name  = "jsa-testapp"

          port {
            container_port = 8080
          }
        }
      }
    }
  }
  
  provisioner "local-exec" {
    command = "az aks get-credentials --overwrite-existing --resource-group jsa-terraform-showcase --name jsa-k8s --admin"
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