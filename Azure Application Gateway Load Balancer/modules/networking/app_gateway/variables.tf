variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "appgw_subnet_id" {
  type        = string
  description = "ID of the dedicated AppGW subnet from networking module"
}

variable "appgw_pip_id" {
  type        = string
  description = "ID of the AppGW public IP from networking module"
}

variable "network_interface_ids" {
  type        = list(string)   # ✅ changed from string to list(string)
  description = "List of NIC IDs to associate with AppGW backend pool"
}

variable "nic_pool_mapping" {
  type = list(object({
    nic_index = number
    pool_name = string
  }))
  description = "Maps each NIC index to a backend pool name"
}






