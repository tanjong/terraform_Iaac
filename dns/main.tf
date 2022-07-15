resource "azurerm_resource_group" "devlab_dns_rg" {
  name     = local.dnsrgname
  location = local.buildregion
}

resource "azurerm_dns_zone" "devlab_dns_zones" {
  name                = local.domainname
  resource_group_name = azurerm_resource_group.devlab_dns_rg.name
}

resource "azurerm_dns_txt_record" "devlab_dns_txt_record" {
  name                = "@"
  zone_name           = azurerm_dns_zone.devlab_dns_zones.name
  resource_group_name = azurerm_resource_group.devlab_dns_rg.name
  ttl                 = 60

  record {
    value = "905bc930-ba42-4c98-a03c-175a1dcded93"
  }

  tags = local.dns_tags
}

##........Arecord is needed to point to the appgw........##
resource "azurerm_dns_a_record" "devlab_dns_a_record" {
  name                = "@"
  zone_name           = azurerm_dns_zone.devlab_dns_zones.name
  resource_group_name = azurerm_resource_group.devlab_dns_rg.name
  ttl                 = 60
  records             = ["20.9.16.37"]
}

resource "azurerm_dns_cname_record" "devlab_dns_cname_record" {
  name                = var.cname
  zone_name           = azurerm_dns_zone.devlab_dns_zones.name
  resource_group_name = azurerm_resource_group.devlab_dns_rg.name
  ttl                 = 60
  record              = var.record
}

