variable "vm_name" {
type =string
description = "this is the name for the virtual mechine"  
}

variable "admin_username" {
type =string
description = "This is the admin user name"  
}

variable "admin_password" {
type =string
description = "This is the admin password for the VM"
sensitive = true  
}

variable "vm_size" {
type = string
description = "This is the size of the Virtual Mechine"
default = "Standard_B2s"  
}

variable "vm_count" {
  type        = number
  description = "Number of Linux VMs to create"
  default     = 3
}