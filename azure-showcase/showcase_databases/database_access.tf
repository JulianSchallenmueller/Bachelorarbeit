terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.91.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "random_string" "dbPasswordGen" {
  length  = 127
  upper   = true
  lower   = true
  number  = true
  special = true
}

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "jsa_vault" {
  name                        = "jsa-vault"
  location                    = var.location
  resource_group_name         = var.resource_group_name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = [
      "get", "list", "set", "delete", "recover", "backup", "restore", "purge"
    ]
  }

  network_acls {
    default_action = "Allow"
    bypass         = "AzureServices"
  }
}

resource "azurerm_postgresql_firewall_rule" "pgdatabaseserverfirewallallow" {
  name                = "allowall"
  resource_group_name = var.resource_group_name
  server_name         = azurerm_postgresql_server.pgdatabaseserver.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "255.255.255.255"
}

resource "azurerm_key_vault_secret" "azurekeyvaultpgdatabasepw_password" {
  name         = "database-password"
  value        = random_string.dbPasswordGen.result
  key_vault_id = azurerm_key_vault.jsa_vault.id
}

resource "azurerm_key_vault_secret" "azurekeyvaultpgdatabasepw_user" {
  name         = "database-user"
  value        = "test_db_user"
  key_vault_id = azurerm_key_vault.jsa_vault.id
}