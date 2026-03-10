variable "virtual_machine_name_prefix" {
  type=string  
}

variable "virtual_machine_count" {
  type = number
  default = 2
  validation {
    condition = var.virtual_machine_count<=local.maximum_virtual_machines
    error_message = "The number of virtual machine should not exceed 5"
  }
}