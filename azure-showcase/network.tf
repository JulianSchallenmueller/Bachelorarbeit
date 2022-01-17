resource "azurerm_virtual_network" "vnet" {
  name                = "jsa-tf-showcase-${var.environment}"
  location            = azurerm_resource_group.resourceGroup.location
  resource_group_name = azurerm_resource_group.resourceGroup.name
  address_space       = ["10.0.0.0/16"]
}