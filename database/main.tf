resource "azurerm_resource_group" "devlab_sqldb_rg" {
  name     = join("", [local.main, "sql"])
  location = local.buildregion
}

resource "azurerm_storage_account" "sqldb_storageaccount" {
  name                     = join("", ["sqldb", "saccount"])
  location                 = azurerm_resource_group.devlab_sqldb_rg.location
  resource_group_name      = azurerm_resource_group.devlab_sqldb_rg.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_mssql_server" "sql_server" {
  name                         = join("-", [local.main, "sqlserver"])
  location                     = azurerm_resource_group.devlab_sqldb_rg.location
  resource_group_name          = azurerm_resource_group.devlab_sqldb_rg.name
  version                      = "12.0"
  administrator_login          = join("", [local.main, "sqladmin"])
  administrator_login_password = "4-v3ry-53cr37-p455w0rd" #data.azurerm_key_vault_secret.exisitingkeyvaultsecret.value 
}

resource "azurerm_mssql_database" "sql_database" {
  name         = join("", [local.main, "db"])
  server_id    = azurerm_mssql_server.sql_server.id
  collation    = "SQL_Latin1_General_CP1_CI_AS"
  license_type = "LicenseIncluded"
  max_size_gb    = 2
  read_scale = false
  sku_name       = "S0"
  zone_redundant = false

  #  extended_auditing_policy {
  #  storage_endpoint                        = azurerm_storage_account.sqldb_storageaccount.primary_blob_endpoint
  #  storage_account_access_key              = azurerm_storage_account.sqldb_storageaccount.primary_access_key
  #  storage_account_access_key_is_secondary = true
  #  retention_in_days                       = 6
  # } 

  tags = local.db_tags
}

resource "azurerm_mssql_firewall_rule" "sql_fwRule" {
  name             = join("", [local.main, "fwdevRule", "db"])
  server_id        = azurerm_mssql_server.sql_server.id
  start_ip_address = "75.28.18.240"
  end_ip_address   = "75.28.18.240"
}

