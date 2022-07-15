#/*------------ Appgw RG --------------------*\#
resource "azurerm_resource_group" "devlab_appgw_rg" {
  name     = join("_", [local.main, "appgw", "rg"])
  location = local.buildregion
}

#/*------------Frontend Subnet --------------------*\#
resource "azurerm_subnet" "frontend" {
  name                 = join("-", [local.main, "frontend", "subnet"])
  resource_group_name  = data.azurerm_resource_group.devlab_general_network_rg.name
  virtual_network_name = data.azurerm_virtual_network.devlab_vnet.name
  address_prefixes     = ["10.0.4.0/24"]
}

#/*------------Frontend Subnet Association --------------------*\#
resource "azurerm_subnet_route_table_association" "subnet_rt_assoc_frontend" {
  subnet_id      = azurerm_subnet.frontend.id
  route_table_id = data.azurerm_route_table.devlab_rt.id
}

#/*------------Frontend Subnet Nsg Association --------------------*\#
resource "azurerm_subnet_network_security_group_association" "subnet_nsg_assoc_frontend" {
  subnet_id                 = azurerm_subnet.frontend.id
  network_security_group_id = data.azurerm_network_security_group.devlab_nsg.id
}

#/*------------Backend Subnet --------------------*\#
resource "azurerm_subnet" "backend" {
  name                 = join("-", [local.main, "backend", "subnet"])
  resource_group_name  = data.azurerm_resource_group.devlab_general_network_rg.name
  virtual_network_name = data.azurerm_virtual_network.devlab_vnet.name
  address_prefixes     = ["10.0.5.0/24"]
}

#/*------------Backend Subnet Association --------------------*\#
resource "azurerm_subnet_route_table_association" "subnet_rt_assoc_backend" {
  subnet_id      = azurerm_subnet.backend.id
  route_table_id = data.azurerm_route_table.devlab_rt.id
}

#/*------------Backend Subnet Nsg Association --------------------*\#
resource "azurerm_subnet_network_security_group_association" "subnet_nsg_assoc_backend" {
  subnet_id                 = azurerm_subnet.backend.id
  network_security_group_id = data.azurerm_network_security_group.devlab_nsg.id
}

#/*------------ Public IP --------------------*\#
resource "azurerm_public_ip" "appgw_pip" {
  name                = join("-", [local.main, "appgw", "pip"])
  resource_group_name = azurerm_resource_group.devlab_appgw_rg.name
  location            = local.buildregion
  allocation_method   = "Static"
  sku                 = "Standard"
}

#/*------------ local variable for Appgw --------------------*\#
locals {
  backend_address_pool_name      = "${data.azurerm_virtual_network.devlab_vnet.name}-beap"
  frontend_port_name             = "${data.azurerm_virtual_network.devlab_vnet.name}-feport"
  frontend_ip_configuration_name = "${data.azurerm_virtual_network.devlab_vnet.name}-feip"
  http_setting_name              = "${data.azurerm_virtual_network.devlab_vnet.name}-be-htst"
  listener_name                  = "${data.azurerm_virtual_network.devlab_vnet.name}-httplstn"
  listener_name_https            = "${data.azurerm_virtual_network.devlab_vnet.name}-httpslstn"
  request_routing_rule_name      = "${data.azurerm_virtual_network.devlab_vnet.name}-rqrt"
  redirect_configuration_name    = "${data.azurerm_virtual_network.devlab_vnet.name}-rdrcfg"
}

#------------ Appgw --------------------#
resource "azurerm_application_gateway" "network" {
  name                = join("-", [local.main, "devappgw"])
  resource_group_name = azurerm_resource_group.devlab_appgw_rg.name
  location            = local.buildregion

  sku {
    name     = "WAF_v2"
    tier     = "WAF_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = join("-", [local.main, "ipconf"])
    subnet_id = azurerm_subnet.frontend.id
  }

  frontend_port {
    name = local.frontend_port_name
    port = 80
  }

  frontend_port {
    name = "${data.azurerm_virtual_network.devlab_vnet.name}-443"
    port = 443
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.appgw_pip.id
  }

  backend_address_pool {
    name = local.backend_address_pool_name
  }

  backend_http_settings {
    name                  = local.http_setting_name
    cookie_based_affinity = "Disabled"
    path                  = "/"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }

  backend_http_settings {
    name                  = local.http_setting_name
    cookie_based_affinity = "Disabled"
    path                  = "/"
    port                  = 443
    protocol              = "Https"
    request_timeout       = 60
  }

  ##.........Http Listener..........##
  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Http"
  }

  ##.........Https Listener..........##
  http_listener {
    name                           = local.listener_name_https
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = "${data.azurerm_virtual_network.devlab_vnet.name}-443"
    protocol                       = "Https"
    ssl_certificate_name           = "brooklyntj.net"
  }

  ##........ Request routing rule for Http........##
  request_routing_rule {
    name                       = "req-routehttps"
    rule_type                  = "Basic"
    http_listener_name         = local.listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
    priority                   = 11
  }

  ##........ Request routing rule for Https........## comment this routing request out 1st
  request_routing_rule {
    name                       = local.request_routing_rule_name
    rule_type                  = "Basic"
    http_listener_name         = local.listener_name_https
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
    priority                   = 10
  }

  ##........ Request Configuration for Https........##
  redirect_configuration {
    name                 = "devlab_rdrct"
    redirect_type        = "Permanent"
    target_listener_name = local.listener_name_https
  }

  ssl_certificate {
    name     = local.ssl_certificate
    password = var.pfx_certificate_password
    data     = var.pfx_certificate_data
  }

  ssl_policy {
    policy_type          = "Predefined"
    policy_name          = "AppGwSslPolicy20150501"
    min_protocol_version = "TLSv1_2"
  }

  tags = local.appgw_tags
}

resource "azurerm_network_interface_application_gateway_backend_address_pool_association" "nic_appgw_backend_pool_assoc" {
  network_interface_id    = data.azurerm_network_interface.linux_nic.id
  ip_configuration_name   = local.ipconfname
  backend_address_pool_id = tolist(azurerm_application_gateway.network.backend_address_pool).0.id
}

# ##### FOR A NOT SECURED SERVER SETTING   ###

# #/*------------ Appgw RG --------------------*\#
# resource "azurerm_resource_group" "devlab_appgw_rg" {
#   name     = join("_", [local.main, "appgw"])
#   location = local.buildregion
# }

# #/*------------Frontend Subnet --------------------*\#
# resource "azurerm_subnet" "frontend" {
#   name                 = join("-", [local.main, "frontend", "subnet"])
#   resource_group_name  = data.azurerm_resource_group.devlab_general_network_rg.name
#   virtual_network_name = data.azurerm_virtual_network.devlab_vnet.name
#   address_prefixes     = ["10.0.4.0/24"]
# }

# #/*------------Frontend Subnet Association --------------------*\#
# resource "azurerm_subnet_route_table_association" "subnet_rt_assoc_frontend" {
#   subnet_id      = azurerm_subnet.frontend.id
#   route_table_id = data.azurerm_route_table.devlab_rt.id
# }

# #/*------------Frontend Subnet Nsg Association --------------------*\#
# resource "azurerm_subnet_network_security_group_association" "subnet_nsg_assoc_frontend" {
#   subnet_id                 = azurerm_subnet.frontend.id
#   network_security_group_id = data.azurerm_network_security_group.devlab_nsg.id
# }

# #/*------------Backend Subnet --------------------*\#
# resource "azurerm_subnet" "backend" {
#   name                 = join("-", [local.main, "backend", "subnet"])
#   resource_group_name  = data.azurerm_resource_group.devlab_general_network_rg.name
#   virtual_network_name = data.azurerm_virtual_network.devlab_vnet.name
#   address_prefixes     = ["10.0.5.0/24"]
# }

# #/*------------Backend Subnet Association --------------------*\#
# resource "azurerm_subnet_route_table_association" "subnet_rt_assoc_backend" {
#   subnet_id      = azurerm_subnet.backend.id
#   route_table_id = data.azurerm_route_table.devlab_rt.id
# }

# #/*------------Backend Subnet Nsg Association --------------------*\#
# resource "azurerm_subnet_network_security_group_association" "subnet_nsg_assoc_backend" {
#   subnet_id                 = azurerm_subnet.backend.id
#   network_security_group_id = data.azurerm_network_security_group.devlab_nsg.id
# }

# #/*------------ Public IP --------------------*\#
# resource "azurerm_public_ip" "appgw_pip" {
#   name                = join("-", [local.main, "appgw", "pip"])
#   resource_group_name = azurerm_resource_group.devlab_appgw_rg.name
#   location            = local.buildregion
#   allocation_method   = "Static"
#   sku                 = "Standard"
# }

# #/*------------ local variable for Appgw --------------------*\#
# locals {
#   backend_address_pool_name      = "${data.azurerm_virtual_network.devlab_vnet.name}-beap"
#   frontend_port_name             = "${data.azurerm_virtual_network.devlab_vnet.name}-feport"
#   frontend_ip_configuration_name = "${data.azurerm_virtual_network.devlab_vnet.name}-feip"
#   http_setting_name              = "${data.azurerm_virtual_network.devlab_vnet.name}-be-htst"
#   listener_name                  = "${data.azurerm_virtual_network.devlab_vnet.name}-httplstn"
#   request_routing_rule_name      = "${data.azurerm_virtual_network.devlab_vnet.name}-rqrt"
#   redirect_configuration_name    = "${data.azurerm_virtual_network.devlab_vnet.name}-rdrcfg"
# }


# #/*------------ Appgw --------------------*\#
# resource "azurerm_application_gateway" "network" {
#   name                = join("-", [local.main, "devappgw"])
#   resource_group_name = azurerm_resource_group.devlab_appgw_rg.name
#   location            = local.buildregion

#   sku {
#     name     = "WAF_v2"
#     tier     = "WAF_v2"
#     capacity = 2
#   }

#   gateway_ip_configuration {
#     name      = join("-", [local.main, "ipconf"])
#     subnet_id = azurerm_subnet.frontend.id
#   }

#   frontend_port {
#     name = local.frontend_port_name
#     port = 80
#   }

#   frontend_ip_configuration {
#     name                 = local.frontend_ip_configuration_name
#     public_ip_address_id = azurerm_public_ip.appgw_pip.id
#   }

#   backend_address_pool {
#     name = local.backend_address_pool_name
#   }

#   backend_http_settings {
#     name                  = local.http_setting_name
#     cookie_based_affinity = "Disabled"
#     path                  = "/"
#     port                  = 80
#     protocol              = "Http"
#     request_timeout       = 60
#   }
#   ##.........Http Listener..........##
#   http_listener {
#     name                           = local.listener_name
#     frontend_ip_configuration_name = local.frontend_ip_configuration_name
#     frontend_port_name             = local.frontend_port_name
#     protocol                       = "Http"
#   }

#   ##........ Request routing rule for Http........##
#   request_routing_rule {
#     name                       = local.request_routing_rule_name
#     rule_type                  = "Basic"
#     http_listener_name         = local.listener_name
#     backend_address_pool_name  = local.backend_address_pool_name
#     backend_http_settings_name = local.http_setting_name
#     priority                   = 10
#   }

#   tags = local.appgw_tags

# }


