variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "virtual_machine_count" {
  type = number
}

variable "virtual_network_interfaces_ids" {
  type = list(string)
}




