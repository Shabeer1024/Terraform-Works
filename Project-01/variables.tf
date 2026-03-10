

variable "app_environment" {
  type = map(object({
    virtualnetworkname = string
    virtualnetworkcidrblock = string
    subnets = map(object({
      cidrblock = string
    }))
    natworkinterfacename = string
    publicipaddressname = string
    virtualmachinename = string
  }))
}

variable "admin_password" {
  type = string
  description = "This is the admin password of the Virtual Machine"
  sensitive = true
}