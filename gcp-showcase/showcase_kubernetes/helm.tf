provider "helm" {
  kubernetes {
    host = "https://${google_container_cluster.jsa_showcase_gke.endpoint}"

    token                  = data.google_client_config.default.access_token
    cluster_ca_certificate = base64decode(google_container_cluster.jsa_showcase_gke.master_auth[0].cluster_ca_certificate)
    client_certificate     = base64decode(google_container_cluster.jsa_showcase_gke.master_auth[0].client_certificate)
    client_key             = base64decode(google_container_cluster.jsa_showcase_gke.master_auth[0].client_key)
  }
}

resource "kubernetes_namespace" "nginxNamespace" {
  metadata {
    name = "nginx-ingress"
  }
}

resource "helm_release" "nginxIngressController" {
  name       = "ingress"
  repository = "https://helm.nginx.com/stable"
  chart      = "nginx-ingress"
  wait       = false
  namespace  = "nginx-ingress"

  set {
    name  = "controller.service.loadBalancerIP"
    value = google_container_cluster.jsa_showcase_gke.endpoint
  }

  depends_on = [kubernetes_namespace.nginxNamespace]
}