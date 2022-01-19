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

resource "azurerm_resource_group" "jsa_playground" {
  name     = "jsa-playground"
  location = "West Europe"
}

resource "azurerm_virtual_network" "jsa_playground" {
  name                = "network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.jsa_playground.location
  resource_group_name = azurerm_resource_group.jsa_playground.name
}

resource "azurerm_subnet" "jsa_playground" {
  name                 = "jsa_playground"
  resource_group_name  = azurerm_resource_group.jsa_playground.name
  virtual_network_name = azurerm_virtual_network.jsa_playground.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "jsa_playground" {
  name                = "jsa_playground"
  location            = azurerm_resource_group.jsa_playground.location
  resource_group_name = azurerm_resource_group.jsa_playground.name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.jsa_playground.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_postgresql_server" "pgdatabaseserver" {
  name                = "jsa-playground"
  location            = "westeurope"
  resource_group_name = azurerm_resource_group.jsa_playground.name

  # 2 vCores, 10.4 GB RAM
  sku_name = "GP_Gen5_2"

  storage_mb                    = 10240
  backup_retention_days         = 7
  geo_redundant_backup_enabled  = false
  auto_grow_enabled             = false
  public_network_access_enabled = true
  administrator_login           = "testadm"
  administrator_login_password  = "test1234#"
  version                       = "11"
  ssl_enforcement_enabled       = true
}