terraform {
#   backend "azurerm" {
#     resource_group_name  = "backend-storage"
#     storage_account_name = "jsastorage"
#     container_name       = "tfstate"
#     key                  = "playground.terraform.tfstate"
#   }

  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "2.92.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "West Europe"
}

resource "azurerm_kubernetes_cluster" "example" {
  name                = "example-aks1"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  dns_prefix          = "exampleaks1"

  default_node_pool {
    name       = "default"
    node_count = 2

    # 2 vCPU, 7.5 GB RAM, 100 GB SSD
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }
}