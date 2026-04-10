variable "resource_group_name" { 
    type = string 
}

variable "location" { 
    type = string 
}

variable "firewall_private_ip" {        # ← must exist here
  type        = string
  description = "Private IP of the Azure Firewall"
}

variable "subnet_ids" {                 # ← must match exactly what root passes
  type        = list(string)
  description = "List of subnet IDs to associate with the route table"
}








