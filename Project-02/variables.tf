

variable "app_environment" {
  type = map(object(
    {
    virtualnetworkname = string
    virtualnetworkcidrblock = string
    subnets = map(object(
    {
      cidrblock = string
      machine = map(object(
      {
      natworkinterfacename = string
      publicipaddressname = string
      }
      ))
    }))
  }
  ))
}

variable "admin_password" {
  type = string
  description = "This is the admin password of the Virtual Machine"
  sensitive = true
}

variable "admin_username" {
  type = string
  description = "This is the admin Username of the Virtual Machine"
  sensitive = true  
}