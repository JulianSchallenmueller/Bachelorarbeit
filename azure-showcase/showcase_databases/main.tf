resource "azurerm_postgresql_server" "pgdatabaseserver" {
  name                = "jsa-psql"
  location            = var.location
  resource_group_name = var.resource_group_name

  sku_name = "B_Gen5_2"

  storage_mb                    = 5120
  backup_retention_days         = 7
  geo_redundant_backup_enabled  = false
  auto_grow_enabled             = true
  public_network_access_enabled = true
  administrator_login           = "testadm"
  administrator_login_password  = random_string.dbPasswordGen.result
  version                       = "11"
  ssl_enforcement_enabled       = true
}

resource "azurerm_postgresql_database" "orderdomain_db" {
  name                = "orderdomain"
  resource_group_name = var.resource_group_name
  server_name         = azurerm_postgresql_server.pgdatabaseserver.name
  charset             = "UTF8"
  collation           = "English_United States.1252"
}

resource "azurerm_postgresql_database" "manufacturedomain_db" {
  name                = "manufacturedomain"
  resource_group_name = var.resource_group_name
  server_name         = azurerm_postgresql_server.pgdatabaseserver.name
  charset             = "UTF8"
  collation           = "English_United States.1252"
}

resource "azurerm_postgresql_database" "supplierdomain_db" {
  name                = "supplierdomain"
  resource_group_name = var.resource_group_name
  server_name         = azurerm_postgresql_server.pgdatabaseserver.name
  charset             = "UTF8"
  collation           = "English_United States.1252"
}