data "azurerm_client_config" "current" {}

data "azurerm_subscription" "primary" {}

data "azurerm_virtual_network" "devlab_vnet" {
  name                = local.existingvnet
  resource_group_name = local.existingmainrg
}

data "azurerm_resource_group" "devlab_general_network_rg" {
  name = local.existingmainrg
}

data "azurerm_network_security_group" "devlab_nsg" {
  name                = local.existingnsg
  resource_group_name = local.existingmainrg
}

data "azurerm_route_table" "devlab_rt" {
  name                = local.existingrt
  resource_group_name = local.existingmainrg
}

# data "azurerm_key_vault_secret" "secret" {
#   name         = "ssl_password"
#   key_vault_id = data.azurerm_key_vault.vault.id
# }

# data "azurerm_key_vault" "vault" {
#   name                = join("", ["dev", "lab", "masterkeyvault"])
#   resource_group_name = "devlab_vault_rg"
# }

data "azurerm_network_interface" "linux_nic" {
  name                = join("_", ["linux", "nic"])
  resource_group_name = "devlab_linuxvm_rg"
}