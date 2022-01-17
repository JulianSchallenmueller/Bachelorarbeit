
data "azurerm_container_registry" "containerregistry" {
  name                = "jsacontainerregistry"
  resource_group_name = "jsa-terraform-registry"
}