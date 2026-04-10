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
type = string
}

variable "network_interface_count" {
  type = string
}

variable "public_ip_address_interface" {
  type = string
}

variable "network_security_rules" {
  type = list(object({
    priority = number
    destination_port_range = string
  }
  ))
}

variable "virtual_machine_count" {
  type = string
}

# variable "route_table_id" {
#   description = "Route table ID to associate with all subnets"
#   type        = string
# }

variable "firewall_private_ip" {
  type        = string
  description = "Private IP of Azure Firewall"
}

variable "allowed_mgmt_ips" {
  type    = list(string)
  default = ["123.123.123.123"]                  # replace with your IP
}

variable "lion_dc1_private_ip" {
  type    = string
  default = "10.0.0.4"                             # typical first VM IP in subnet0
}

variable "lion_dc2_private_ip" {
  type    = string
  default = "10.0.1.4"                             # typical first VM IP in subnet1
}








