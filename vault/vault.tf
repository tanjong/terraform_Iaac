resource "azurerm_resource_group" "devlab_vault_rg" {
  name     = "vault-rg"
  location = lower("Centralus")
  provider = azurerm.vault
}

resource "azurerm_key_vault" "vault" {
  provider                    = azurerm.vault
  name                        = join("", ["dev", "lab", "masterkeyvault"])
  location                    = azurerm_resource_group.devlab_vault_rg.location
  resource_group_name         = azurerm_resource_group.devlab_vault_rg.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get", "List"
    ]

    secret_permissions = [
      "Get", "Backup", "Delete", "List", "Purge", "Recover", "Restore", "Set",
    ]

    storage_permissions = [
      "Get", "List"
    ]
  }
}

#Create KeyVault VM password
resource "random_password" "winvm_password" {
  length  = 20
  special = true
}

## ------------------------------------------##
#Create Key Vault Secret
resource "azurerm_key_vault_secret" "win_keyvault_secret" {
  name         = upper("windowsserverpassword")
  value        = random_password.winvm_password.result
  key_vault_id = azurerm_key_vault.vault.id
  depends_on   = [azurerm_key_vault.vault]
}

## ------------------------------------------##
#Create KeyVault password for ssl
# resource "random_password" "ssl_password" {
#   length  = 11
#   special = false
# }

## ------------------------------------------##
# #Create Key Vault Secret for ssl
# resource "azurerm_key_vault_secret" "ssl_keyvault_secret" {
#   name         = "ssl_password"
#   value        = random_password.ssl_password.result
#   key_vault_id = azurerm_key_vault.vault.id
#   depends_on = [azurerm_key_vault.vault]


## ------------------------------------------##
#Create KeyVault password for db
# resource "random_password" "sqldb_password" {
#   length  = 11
#   special = false
# }

# ## ------------------------------------------##
# #Create Key Vault Secret for db
# resource "azurerm_key_vault_secret" "sqldb_keyvault_secret" {
#   name         = upper("msqlpassword")
#   value        = random_password.sqldb_password.result
#   key_vault_id = azurerm_key_vault.vault.id
#   depends_on = [azurerm_key_vault.vault]