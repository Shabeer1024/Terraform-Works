variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "vnet_name" {
  type = string
}

variable "vnet_address_prefix" {
  type = string
}

variable "vnet_subnet_count" {
type = number
}

variable "network_interface_count" {
  type = number
}

variable "public_ip_address_interface" {
  type = number
}

variable "network_security_rules" {
  type = list(object({
    priority = number
    destination_port_range = string
  }
  ))
}

variable "virtual_machine_count" {
  type = number
}






