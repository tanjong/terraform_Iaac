# resource "azurerm_resource_group" "devlab_statestorage_rg" {
#   name     = join("_", ["devlab", "statestorage", "rg"])
#   location = local.buildregion
# }

# resource "azurerm_storage_account" "statestorage_account" {
#   name                     = join("", ["statestorage", "account"])
#   resource_group_name      = azurerm_resource_group.devlab_statestorage_rg.name
#   location                 = azurerm_resource_group.devlab_statestorage_rg.location
#   account_tier             = "Standard"
#   account_replication_type = "GRS"

#   tags = local.server_tags
# }

# resource "azurerm_storage_container" "statestorage_container" {
#   name                  = join("_", ["devlab", "statestorage", "container"])
#   storage_account_name  = azurerm_storage_account.devlab_statestorage_account.name
#   container_access_type = "private"
# }