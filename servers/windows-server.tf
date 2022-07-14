# resource "azurerm_resource_group" "devlab_winvm_rg" {
#   name     = join("_", [local.main, "winvm", "rg"])
#   location = local.buildregion
# }

# resource "azurerm_network_interface" "win_nic" {
#   name                = join("_", ["win", "nic"])
#   location            = azurerm_resource_group.devlab_winvm_rg.location
#   resource_group_name = azurerm_resource_group.devlab_winvm_rg.name

#   ip_configuration {
#     name                          = "internal"
#     subnet_id                     = data.azurerm_subnet.server_subnet.id
#     private_ip_address_allocation = "Dynamic"
#     public_ip_address_id          = azurerm_public_ip.win_pip.id
#   }
# }

# resource "azurerm_public_ip" "win_pip" {
#   name                = join("_", ["win", "pip"])
#   location            = azurerm_resource_group.devlab_winvm_rg.location
#   resource_group_name = azurerm_resource_group.devlab_winvm_rg.name
#   allocation_method   = "Static"

#   tags = local.server_tags
# }

# resource "azurerm_windows_virtual_machine" "win_vm" {
#   name                = join("-", ["win", "vm"])
#   location            = azurerm_resource_group.devlab_winvm_rg.location
#   resource_group_name = azurerm_resource_group.devlab_winvm_rg.name
#   size                = "Standard_D2s_v3"
#   admin_username      = "devlabadmin"
#   admin_password      = data.azurerm_key_vault_secret.exisitingkeyvaultsecret.value #"P@SSW0RD!" 
#   network_interface_ids = [
#     azurerm_network_interface.win_nic.id,
#   ]

#   os_disk {
#     caching              = "ReadWrite"
#     storage_account_type = "Standard_LRS"
#   }

#   source_image_reference {
#     publisher = "MicrosoftWindowsServer"
#     offer     = "WindowsServer"
#     sku       = "2019-Datacenter"
#     version   = "latest"
#   }
#   tags = local.server_tags
# }