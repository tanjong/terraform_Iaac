locals {
  # Common tags to be assigned to all resources
  appgw_tags = {
    Service     = "devOps"
    Owner       = "devlab_admin"
    environment = "Development"
    ManagedWith = "terraform"
  }
  main           = "devlab"
  buildregion    = lower("centralus")
  existingvnet   = "devlab_vnet"
  existingmainrg = "devlab_general_network_rg"
  existingnsg    = "devlab_nsg"
  existingrt     = "devlab_rt"
  ipconfname      = "internal"
  ssl_certificate = "brooklyntj.net"
}