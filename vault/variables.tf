variable "devopslab_general_network" {
  type    = string
  default = "devopslab_general_network"
}

variable "location" {
  type    = string
  default = "Central US"
}

variable "devopslab-nsg" {
  type    = string
  default = "devopslab-nsg"
}

variable "devopslab_vnet" {
  type    = string
  default = "devopslab_vnet"
}

variable "address_space" {
  type    = list(string)
  default = ["10.0.0.0/16"]
}

variable "dns_servers" {
  type    = list(string)
  default = ["10.0.0.4", "10.0.0.5"]
}

variable "devopslab_rt" {
  type    = string
  default = "devopslab_rt"
}

variable "devopslab_route1" {
  type    = string
  default = "devopslab_route1"
}

variable "address_prefix" {
  type    = string
  default = "10.1.0.0/16"
}

variable "next_hop_type" {
  type    = string
  default = "VnetLocal"
}

variable "disable_bgp_route_propagation" {
  type    = string
  default = "false"
}

variable "database_subnet" {
  type    = string
  default = "database_subnet"
}

variable "application_subnet" {
  type    = string
  default = "application_subnet"
}

variable "address_prefixes_database" {
  type    = list(string)
  default = ["10.0.1.0/24"]
}

variable "server_subnet" {
  type    = string
  default = "server_subnet"
}

variable "address_prefixes_application" {
  type    = list(string)
  default = ["10.0.2.0/24"]
}

variable "address_prefixes_server" {
  type    = list(string)
  default = ["10.0.3.0/24"]
}

variable "linux" {
  type    = string
  default = "linux"
}

variable "direction" {
  type    = string
  default = "Inbound"
}

variable "access" {
  type    = string
  default = "Allow"
}

variable "protocol" {
  type    = string
  default = "Tcp"
}

variable "source_port_range" {
  type    = string
  default = "*"
}

variable "destination_port_range" {
  type    = string
  default = "22"
}

variable "source_address_prefix" {
  type    = string
  default = "75.28.18.240/32"
}

variable "destination_address_prefix" {
  type    = string
  default = "VirtualNetwork"
}






