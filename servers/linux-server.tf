resource "azurerm_resource_group" "devlab_linuxvm_rg" {
  name     = join("_", [local.main, "linuxvm", "rg"])
  location = local.buildregion
}


resource "azurerm_network_interface" "linux_nic" {
  name                = join("_", ["linux", "nic"])
  location            = azurerm_resource_group.devlab_linuxvm_rg.location
  resource_group_name = azurerm_resource_group.devlab_linuxvm_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.server_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.linux_pip.id
  } 
}

resource "azurerm_public_ip" "linux_pip" {
  name                = join("_", ["linux", "pip"])
  location            = azurerm_resource_group.devlab_linuxvm_rg.location
  resource_group_name = azurerm_resource_group.devlab_linuxvm_rg.name
  allocation_method   = "Static"

  tags = local.server_tags
}


resource "azurerm_linux_virtual_machine" "linux_vm" {
  name                = join("-", ["linux", "vm"])
  location            = azurerm_resource_group.devlab_linuxvm_rg.location
  resource_group_name = azurerm_resource_group.devlab_linuxvm_rg.name
  size                = "Standard_D2s_v3"
  admin_username      = "adminuser"
  # user_data           = data.template_cloudinit_config.userdata.rendered #use for data lookups
  network_interface_ids = [
    azurerm_network_interface.linux_nic.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDwayP+F+KbuVAoVdF0Kbe7cadEAivVSbu4fmxd66BpJyqPlsse9u8n/kUY4ROrw4q2tX3G/0YEklDuQ8ve3uKeIw4MUnfNOIg6fgOYjWb7i8M+qy1QP33at2QxlP24VxttTFvJUSb0KZhXcl/7P1g7YLp1FAIMWtOS7oJHma2320iIl18JSs0Tlpbbn3FHxrYQlr+aWA4XEOm35HI9TtuZY+/uP9SP97hSXWgwQA2anyqy0X9gk+WaK8MyuFEcNCc8aaZfUk+JnWsjq5/7JeLSODzDhR/AgfyuX1lMLwfwQanrH1KF+dwDLDwmRIXW2fl8pECHvmll70UuGwD78W6IcgHDT11CuWOJmpYLtUOR2L4R266V1bFH4OqBv2oxjyD8g04Np3/zQq7OjUerKDXcUsIE+9ZZOWYJJoc3weQcuVTfuvReXLrrz2FvQPFr9K0eKUrDAip2DvCk/bughz/TELJvNMuVbKSR4MPysOi/DpBfv2Xq7nZB2Ztkg3VM/lc= njiet@LAPTOP-KAMNFCIU"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}