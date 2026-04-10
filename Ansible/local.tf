locals {
  resource_location="Central Us"
  virtual_network={
    name="Vnet01"
    address_prefixes=["10.192.0.0/16"]
  }
  subnet_address_prefix=["10.192.0.0/24","10.192.1.0/24"]
  subnets=[
    {
        name="websubnet01"
        address_prefixes=["10.192.0.0/24"]
    },  
    {
        name="appsubnet02"
        address_prefixes=["10.192.1.0/24"]
    }
  ]
}



