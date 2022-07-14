
data "azurerm_client_config" "current" {}

data "azurerm_subscription" "primary" {}

# data "azuread_client_config" "current" {}

data "azurerm_resource_group" "devlab_general_network_rg" {
  name = local.existingmainrg
}

data "azurerm_subnet" "server_subnet" {
  name                 = "server_subnet"
  virtual_network_name = local.existingvnet
  resource_group_name  = local.existingmainrg
}

data "azurerm_network_security_group" "devlab_nsg" {
  name                = local.existingnsg
  resource_group_name = local.existingmainrg
}

data "azurerm_virtual_machine" "linux_vm" {
  name                = local.existinglinuxvm
  resource_group_name = local.existinglinuxvmrg
}

data "azurerm_route_table" "devlab_rt" {
  name                = local.existingrt
  resource_group_name = local.existingmainrg
}

# data "azurerm_key_vault_secret" "exisitingkeyvaultsecret" {
#   name         = local.exisitingkeyvaultsecret
#   key_vault_id = data.azurerm_key_vault.existingkeyvault.id
# }

# data "azurerm_key_vault" "existingkeyvault" {
#   name                = local.existingkeyvault
#   resource_group_name = local.existingkeyvaultrg
# }

## ----- Run Userdata ----- ##
data "template_cloudinit_config" "userdata" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/x-shellscript"
    filename     = "nginx"
    content = templatefile("./templates/apache.tpl",

      {
        db_username = var.db_username
        db_password = var.db_password
        db_name     = var.db_name
        # mssql_sqlserver = data.azurerm_mssql_server.devlab_sqldb_rg.fully_qualified_domain_name
        # appgateway = data.azurerm_application_gateway.network.id
    })
  }
}

# data "azurerm_mssql_server" "sql_server" {
#   name                = join("-", [local.main, "sqlserver"])
#   resource_group_name = "devlab_sqldb_rg"
# }

# data "azurerm_application_gateway" "network" {
#   name                = join("_", [local.main, "appgw", "rg"])
#   resource_group_name = "devlab_appgw_rg"
# }
