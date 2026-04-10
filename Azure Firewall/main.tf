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

# module "load-balance" {
#   source = "./modules/networking/loadbalancer"
#   resource_group_name = var.resource_group_name
#   location = var.location
#   number_of_machine = var.virtual_machine_count
#   virtual_network_id = module.network.virtual_network_id
#   network_interface_private_ip_address = module.network.network_interface_private_ip_address  
# }

module "firewall" {
  source               = "./modules/networking/firewall"
  location             = var.location
  resource_group_name  = var.resource_group_name
  firewall_subnet_id   = module.network.firewall_subnet_id   # ← from network outputs
  firewall_pip_id      = module.network.firewall_pip_id      # ← from network outputs
  firewall_policy_id  = module.firewall_policy.firewall_policy_id
  depends_on          = [module.firewall_policy]     
}

module "routetable" {
  source               = "./modules/networking/route_table"
  location             = var.location
  resource_group_name  = var.resource_group_name  
  firewall_private_ip = module.firewall.firewall_private_ip   
  subnet_ids = module.network.subnet_ids
  depends_on          = [module.firewall]
}

module "firewall_policy" {
  source                     = "./modules/networking/firewall_policy"
  firewall_policy_name       = "fwpol-prod"
  rule_collection_group_name = "rcg-prod"
  resource_group_name        = var.resource_group_name
  location                   = var.location
  sku                        = "Standard"
  threat_intel_mode          = "Alert"
  trusted_networks           = ["10.0.0.0/24", "10.0.1.0/24"]
  allowed_mgmt_ips           = var.allowed_mgmt_ips
  firewall_public_ip         = module.network.firewall_public_ip  # IP value, not ID
  jumpbox_private_ip         = var.lion_dc1_private_ip
  lion_dc2_private_ip        = var.lion_dc2_private_ip
}






