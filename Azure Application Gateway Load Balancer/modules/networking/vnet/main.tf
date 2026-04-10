resource "azurerm_virtual_network" "Vnet01" {
  name                = var.vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = [var.vnet_address_prefix]
}

#------------------------- Subnets -----------------------------

resource "azurerm_subnet" "Network_subnets" {
  count = var.vnet_subnet_count
  name                 = "subnet${count.index}"
  resource_group_name = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.Vnet01.name
  address_prefixes     = [cidrsubnet(var.vnet_address_prefix,8,count.index)]
}

#------------------Dedicated subnet --------------------------

# Dedicated subnet for App Gateway (v2 requirement)
resource "azurerm_subnet" "appgw_subnet" {
  name                 = "snet-appgateway"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.Vnet01.name
  address_prefixes     = [cidrsubnet(var.vnet_address_prefix,8,10)]
}

#------------------Dedicated Publuc IP for AGW --------------------------

resource "azurerm_public_ip" "appgw_pip" {
  name                = "pip-appgw-d2click"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}


#------------------------ Public Ip address --------------------

    resource "azurerm_public_ip" "Public_Ipaddress" {
    count = var.public_ip_address_interface
    name                = "public-ip01${count.index}"
    resource_group_name = var.resource_group_name
    location            = var.location
    allocation_method   = "Static"
  }

  #-----------------------Network Interface ------------------

  resource "azurerm_network_interface" "Network_Interface" {
    count = var.network_interface_count
    name = "interface-0${count.index+1}"
    location            = var.location
    resource_group_name = var.resource_group_name

    ip_configuration {
      name                          = "internal"
      subnet_id                     = azurerm_subnet.Network_subnets[count.index].id
      private_ip_address_allocation = "Dynamic"
      public_ip_address_id = azurerm_public_ip.Public_Ipaddress[count.index].id
    }
  }

  #------------------- NSG ---------------------------

  resource "azurerm_network_security_group" "Network_Security_Group" {
    name = "network-nsg"
    location            = var.location
    resource_group_name = var.resource_group_name

  dynamic security_rule {
      for_each = toset(var.network_security_rules)
      content {
      name                       = "Allow-${security_rule.value.destination_port_range}"
      priority                   =  security_rule.value.priority
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = security_rule.value.destination_port_range
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  }
  }

  #----------------------------- Network Interface --------------

    resource "azurerm_subnet_network_security_group_association" "subnet_nsg" {
    count = var.vnet_subnet_count
    subnet_id                 = azurerm_subnet.Network_subnets[count.index].id
    network_security_group_id = azurerm_network_security_group.Network_Security_Group.id
  }


#   #--------------------- AGW Backenpool  -------------------------

# # ── Backend Pool Associations ──
# resource "azurerm_network_interface_application_gateway_backend_address_pool_association" "appgw_assoc" {
#   count = var.network_interface_count
#   network_interface_id    = azurerm_network_interface.Network_Interface[count.index].id  # ✅ references the NIC above
#   ip_configuration_name   = "internal"
#   backend_address_pool_id = tolist(azurerm_application_gateway.appgw.backend_address_pool)[0].id
# }






