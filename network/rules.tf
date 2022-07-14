#RULES FOR WINDOWS SERVERS
resource "azurerm_network_security_rule" "RDP" {
  name                        = "RDP"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = "75.28.18.240/32"
  destination_address_prefix  = "VirtualNetwork"
 resource_group_name         = azurerm_resource_group.devlab_general_network_rg.name
 network_security_group_name = azurerm_network_security_group.devlab_nsg.name
}


#RULES FOR LINUX SERVERS
resource "azurerm_network_security_rule" "Linux" {
  name                        = var.linux
  priority                    = 101
  direction                   = var.direction
  access                      = var.access
  protocol                    = var.protocol
  source_port_range           = var.source_port_range
  destination_port_range      = var.destination_port_range
  source_address_prefix       = var.source_address_prefix
  destination_address_prefix  = var.destination_address_prefix
  resource_group_name         = azurerm_resource_group.devlab_general_network_rg.name
  network_security_group_name = azurerm_network_security_group.devlab_nsg.name
}

#RULES FOR HTTP SERVERS
resource "azurerm_network_security_rule" "HTTP" {
  name                        = "HTTP"
  priority                    = 102
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "75.28.18.240/32"
  destination_address_prefix  = "VirtualNetwork"
  resource_group_name         = azurerm_resource_group.devlab_general_network_rg.name
  network_security_group_name = azurerm_network_security_group.devlab_nsg.name
}

#RULES FOR LINUX SERVERS
resource "azurerm_network_security_rule" "AppgwRule" {
  name                        = "AppgwRule"
  priority                    = 103
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "65200-65535"
  source_address_prefix       = "GatewayManager"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.devlab_general_network_rg.name
  network_security_group_name = azurerm_network_security_group.devlab_nsg.name
}

#RULES FOR HTTPS SERVERS
resource "azurerm_network_security_rule" "HTTPS" {
  name                        = "HTTPS"
  priority                    = 104
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "75.28.18.240/32"
  destination_address_prefix  = "VirtualNetwork"
  resource_group_name         = azurerm_resource_group.devlab_general_network_rg.name
  network_security_group_name = azurerm_network_security_group.devlab_nsg.name
}
