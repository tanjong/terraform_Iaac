variable "path_to_publickey" {
  type    = string
  default = "linuxvmkey.pub"
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type = string
}

variable "db_name" {
  type = string
}

variable "windowssecret" {}

# variable "devlab_statestorage_rg" {
#   type    = string
#   default = "devlab_statestorage_rg"
# }

# variable "statestorage_account" {
#   type    = string
#   default = "statestorage_account"
# }
