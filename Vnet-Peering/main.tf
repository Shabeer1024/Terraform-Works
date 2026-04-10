module "resource-group" {
  source = "./modules/general/resource"
  resource_group_name = var.resource_group_name
  location = var.location
}

module "network" {
  source = "./modules/networking/vnet"
  for_each = var.environment

  resource_group_name = var.resource_group_name
  location = var.location
  vnet_name = each.value
  vnet_address_prefix = each.value.virtual_network_name
  vnet_subnet_count = each.value.subnet_count
  network_interface_count = each.value.network_interface_count
  public_ip_address_count = each.value.public_ip_address_count
  network_security_rules = var.network_security_rules
  virtual_machine_count = each.value.virtual_machine_count
  depends_on = [ module.resource-group ]
  resource_prefix =each.key
}

module "machines" {
  source = "./modules/compute/VirtualMachines"
  resource_group_name = var.resource_group_name
  location = var.location
  virtual_machine_count = var.virtual_machine_count
  virtual_network_interfaces_ids = module.network.virtual_network_interfaces_ids
}

# module "load-balance" {
#   source = "./modules/networking/loadbalancer"
#   resource_group_name = var.resource_group_name
#   location = var.location
#   number_of_machine = var.virtual_machine_count
#   virtual_network_id = module.network.virtual_network_id
#   network_interface_private_ip_address = module.network.network_interface_private_ip_address  
# }



