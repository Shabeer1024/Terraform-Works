module "resource-group" {
  source = "./modules/general/resource"
  resource_group_name = var.resource_group_name
  location = var.location
}

module "network" {
  source = "./modules/networking/vnet"
  resource_group_name = var.resource_group_name
  location = var.location
  vnet_name = var.vnet_name
  vnet_address_prefix = var.vnet_address_prefix
  vnet_subnet_count = var.vnet_subnet_count
  network_interface_count = var.network_interface_count
  public_ip_address_interface = var.public_ip_address_interface
  network_security_rules = var.network_security_rules
  virtual_machine_count = var.virtual_machine_count
  depends_on = [ module.resource-group ]
}

module "machines" {
  source = "./modules/compute/VirtualMachines"
  resource_group_name = var.resource_group_name
  location = var.location
  virtual_machine_count = var.virtual_machine_count
  virtual_network_interfaces_ids = module.network.virtual_network_interfaces_ids
}

module "load-balance" {
  source = "./modules/networking/loadbalancer"
  resource_group_name = var.resource_group_name
  location = var.location
  number_of_machine = var.virtual_machine_count
  virtual_network_id = module.network.virtual_network_id
  network_interface_private_ip_address = module.network.network_interface_private_ip_address  
}