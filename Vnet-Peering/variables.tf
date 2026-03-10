variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "vnet_name" {
  type = string
}

# variable "public_ip_address_count" {
#   type = number
# }


# variable "vnet_address_prefix" {
#   type = string
# }

# variable "vnet_subnet_count" {
# type = string
# }

# variable "network_interface_count" {
#   type = string
# }

# variable "public_ip_address_interface" {
#   type = string
# }

variable "network_security_rules" {
  type = list(object({
    priority = number
    destination_port_range = string
  }
  ))
}

# variable "virtual_machine_count" {
#   type = string
# }

variable "environment" {
  type=map(object(
  {
    virtual_network_name = string
    virtual_network_address_space = string
    subnet_count = number
    network_interface_count = number
    public_ip_address_count = number
    virtual_machine_count = number
  }))
}