terraform {
  backend "azurerm" {
    resource_group_name  = "backend-storage"
    storage_account_name = "jsastorage"
    container_name       = "tfstate"
    key                  = "dev.terraform.tfstate"
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.91.0"
    }

    local = {
      source  = "hashicorp/local"
      version = "2.1.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.1.0"
    }

    null = {
      source  = "hashicorp/null"
      version = "3.1.0"
    }

    template = {
      source  = "hashicorp/template"
      version = "2.2.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "resourceGroup" {
  name     = "jsa-terraform-showcase"
  location = var.location
}

module "showcase_databases" {
  source = "./showcase_databases"

  resource_group_name = azurerm_resource_group.resourceGroup.name
  network             = azurerm_virtual_network.vnet.name
  location            = var.location
}

module "showcase_kubernetes" {
  source = "./showcase_kubernetes"

  resource_group_name = azurerm_resource_group.resourceGroup.name
  network             = azurerm_virtual_network.vnet.name
  location            = var.location
  num_nodes           = var.num_nodes
}