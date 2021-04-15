provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "main" {
  name     = "${var.prefix}-rg"
  location = "Canada Central"
}

resource "azurerm_mariadb_server" "mariadb" {
  name                = "${var.prefix}-mariadb"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  administrator_login          = var.db_admin
  administrator_login_password = var.db_password

  sku_name   = "B_Gen5_2"
  storage_mb = 5120
  version    = "10.2"

  auto_grow_enabled             = true
  backup_retention_days         = 7
  geo_redundant_backup_enabled  = false
  public_network_access_enabled = true
  ssl_enforcement_enabled       = true
}

resource "azurerm_mariadb_database" "sample" {
  name                = var.db_name
  resource_group_name = azurerm_resource_group.main.name
  server_name         = azurerm_mariadb_server.mariadb.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}

data "azurerm_mariadb_server" "db_server" {
  name                = azurerm_mariadb_server.mariadb.name
  resource_group_name = azurerm_mariadb_server.mariadb.resource_group_name
}

output "mariadb_server_id" {
  value = data.azurerm_mariadb_server.db_server.id
}

output "mariadb_server_fqdn" {
  value = data.azurerm_mariadb_server.db_server.fqdn
}

output "mariadb_server_location" {
  value = data.azurerm_mariadb_server.db_server.location
}

output "mariadb_server_login" {
  value = data.azurerm_mariadb_server.db_server.administrator_login
}

output "mariadb_server_storage_profile" {
  value = data.azurerm_mariadb_server.db_server.storage_profile
}
