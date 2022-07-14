data "azurerm_client_config" "current" {}

data "azurerm_subscription" "primary" {}

# data "azurerm_key_vault_secret" "exisitingkeyvaultsecret" {
#   name         = local.exisitingkeyvaultsecret
#   key_vault_id = data.azurerm_key_vault.existingkeyvault.id
# }

# data "azurerm_key_vault" "existingkeyvault" {
#   name                = local.existingkeyvault
#   resource_group_name = local.existingkeyvaultrg
# }
