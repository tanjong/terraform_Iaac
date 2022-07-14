locals {
  # Common tags to be assigned to all resources
  network_tags = {
    Service     = "devOps"
    Owner       = "devlabadmin"
    environment = "Development_Network"
    ManagedWith = "terraform"
  }
}