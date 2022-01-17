resource "azurerm_kubernetes_cluster" "jsa_k8s" {
  name                = "jsa-k8s"
  location            = "westeurope"
  resource_group_name = var.resource_group_name
  dns_prefix          = "jsa"
  kubernetes_version  = "1.22.4"

  identity {
    type = "SystemAssigned"
  }

  default_node_pool {
    name       = "default"
    node_count = 2
    vm_size    = "Standard_D2_v2"
  }

  role_based_access_control {
    enabled = true
  }
}

resource "azurerm_role_assignment" "jsa_acrpull_role" {
  scope                = data.azurerm_container_registry.containerregistry.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.jsa_k8s.kubelet_identity[0].object_id
}