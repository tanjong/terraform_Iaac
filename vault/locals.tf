locals {
  # Common tags to be assigned to all resources
  common_tags = {
    Service     = "devOps"
    Owner       = "devopslab_admin"
    environment = "Development"
    ManagedWith = "terraform"
  }

  server        = "devopslap"
  exitingregion = lower("EastUS")
  vnet          = "devopslab_linux_vnet"
  networkrgrg   = "devopslab_winvm_rg"
  object_id     = "e883b6f3-a0fd-4259-91ff-bd268026d49f"
}