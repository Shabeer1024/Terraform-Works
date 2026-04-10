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

resource "azurerm_subnet" "AzureFirewallSubnet" {
  name                 = "AzureFirewallSubnet"           # ← Fixed name, Azure enforces this
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.Vnet01.name
  address_prefixes     = [cidrsubnet(var.vnet_address_prefix, 8, 10)]  # e.g. 10.0.10.0/24
}

resource "azurerm_public_ip" "firewall_pip" {
  name                = "pip-firewall-d2click"
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


  #--------------------- Route Table NAT Rule -------------------------







