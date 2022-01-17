resource "azurerm_public_ip" "jsa_k8s_ingress_ip" {
  name                = "jsa-k8s-ingress-ip"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "helm_release" "nginxIngressController" {
  name       = "ingress"
  repository = "https://helm.nginx.com/stable"
  chart      = "nginx-ingress"
  wait       = false

  set {
    name  = "controller.service.loadBalancerIP"
    value = azurerm_public_ip.jsa_k8s_ingress_ip.ip_address
  }

  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/azure-load-balancer-resource-group"
    value = var.resource_group_name
  }
}