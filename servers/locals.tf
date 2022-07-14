locals {
  # Common tags to be assigned to all resources
  server_tags = {
    Service     = "devOps"
    Owner       = "dev_lab"
    environment = "Development"
    ManagedWith = "terraform"
  }
  main                    = "devlab"
  buildregion             = lower("centralus")
  existingvnet            = "devlab_vnet"
  existingmainrg          = "devlab_general_network_rg"
  existingnsg             = "devlab_nsg"
  exisitingkeyvaultsecret = "WINDOWSSERVERPASSWORD"
  existingkeyvault        = join("-", [local.main, "masterkeyvault"])
  existingkeyvaultrg      = "devlab_vault_rg"
  admin_username          = "devlabadmin"
  existinglinuxvm         = "linux-vm"
  existinglinuxvmrg       = join("_", [local.main, "linuxvm", "rg"])
  existingrt              = "devlab_rt"
}