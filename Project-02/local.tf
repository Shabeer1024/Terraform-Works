locals {
  resource_location = "Central Us"

  networksecuritygroup_rules=[
  {  priority =300
    description_port_range = "22"
    port = "SSH"
  },
  {
    priority = 310
    description_port_range = "80"
    port = "HTTP"
  }
  ]
}



