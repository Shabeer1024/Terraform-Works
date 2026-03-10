


#-------------------------- Resource Group ----------------------

  resource "azurerm_resource_group" "NetworkRG" {
    name     = "NetworkRG"
    location = "Central Us"
  }

#--------------------------- Virtual Netwrok --------------------

resource "azurerm_virtual_network" "Vnet01" {
  name                = var.app_environment.production.virtualnetworkname
  location            = local.resource_location
  resource_group_name = azurerm_resource_group.NetworkRG.name
  address_space       = [var.app_environment.production.virtualnetworkcidrblock]
}

#------------------------- Subnets -----------------------------

resource "azurerm_subnet" "frontend01" {
  for_each = var.app_environment.production.subnets
  name                 = each.key
  resource_group_name  = azurerm_resource_group.NetworkRG.name
  virtual_network_name = azurerm_virtual_network.Vnet01.name
  address_prefixes     = [each.value.cidrblock]
}

resource "azurerm_subnet" "backend01" {
  for_each = var.app_environment.production.subnets
  name                 = each.key
  resource_group_name  = azurerm_resource_group.NetworkRG.name
  virtual_network_name = azurerm_virtual_network.Vnet01.name
  address_prefixes     = [each.value.cidrblock]
}

#-----------------------Network Interface ------------------

  resource "azurerm_network_interface" "frontinterface" {
    for_each = var.app_environment.production.subnets["frontend01"].machine
    name                = each.value.natworkinterfacename
    location            = local.resource_location
    resource_group_name = azurerm_resource_group.NetworkRG.name

    ip_configuration {
      name                          = "internal"
      subnet_id                     = azurerm_subnet.frontend01["frontend01"].id
      private_ip_address_allocation = "Dynamic"
      public_ip_address_id = azurerm_public_ip.pubip[each.key].id
    }
  }

  resource "azurerm_network_interface" "backinterface" {
    for_each = var.app_environment.production.subnets["backend01"].machine
    name                = each.value.natworkinterfacename
    location            = local.resource_location
    resource_group_name = azurerm_resource_group.NetworkRG.name

    ip_configuration {
      name                          = "internal"
      subnet_id                     = azurerm_subnet.frontend01["backend01"].id
      private_ip_address_allocation = "Dynamic"
      public_ip_address_id = azurerm_public_ip.backip[each.key].id
    }
  }



  #---------------------Public Ip -----------------------

    resource "azurerm_public_ip" "pubip" {
    for_each = var.app_environment.production.subnets["frontend01"].machine
    name                = each.value.publicipaddressname
    resource_group_name = azurerm_resource_group.NetworkRG.name
    location            = local.resource_location
    allocation_method   = "Static"
  }

      resource "azurerm_public_ip" "backip" {
    for_each = var.app_environment.production.subnets["backend01"].machine
    name                = each.value.publicipaddressname
    resource_group_name = azurerm_resource_group.NetworkRG.name
    location            = local.resource_location
    allocation_method   = "Static"
  }

#-------------------- NSG app-nsg Rules----------------------------

  resource "azurerm_network_security_group" "app-nsg" {
    name                = "app-nsg"
    location            = local.resource_location
    resource_group_name = azurerm_resource_group.NetworkRG.name

  dynamic "security_rule" {
      for_each = local.networksecuritygroup_rules
      content {
      name                       = "Allow-${security_rule.value.description_port_range}"
      priority                   = security_rule.value.priority
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = security_rule.value.description_port_range
      source_address_prefix      = "*"
      destination_address_prefix = "*"
      }
    }
  }

  #------------------NGS Association--------------------------------

  resource "azurerm_subnet_network_security_group_association" "subnet_front_nsg" {
    for_each = azurerm_subnet.frontend01
    subnet_id                 = azurerm_subnet.frontend01[each.key].id
    network_security_group_id = azurerm_network_security_group.app-nsg.id
  }

  #-------------------------- Virtual Mechine -------------------------


  resource "azurerm_linux_virtual_machine" "Lion-DC" {
    for_each = var.app_environment.production.subnets["frontend01"].machine
    name                = each.key
    resource_group_name = azurerm_resource_group.NetworkRG.name
    location            = local.resource_location
    size                = "Standard_B2s"
    admin_username      = "adam"
    admin_password      = "Bankfab.1234$"
    disable_password_authentication = false
    network_interface_ids = [
    azurerm_network_interface.frontinterface[each.key].id
    ]

    os_disk {
      caching              = "ReadWrite"
      storage_account_type = "Standard_LRS"
    }

    source_image_reference {
      publisher = "Canonical"
      offer     = "ubuntu-24_04-lts"
      sku       = "server"
      version   = "latest"
    }
  }


  resource "azurerm_linux_virtual_machine" "Tiger-DC" {
    for_each = var.app_environment.production.subnets["backend01"].machine
    name                = each.key
    resource_group_name = azurerm_resource_group.NetworkRG.name
    location            = local.resource_location
    size                = "Standard_B2s"
    admin_username      = "adam"
    admin_password      = "Bankfab.1234$"
    disable_password_authentication = false
    network_interface_ids = [
    azurerm_network_interface.backinterface[each.key].id
    ]

    os_disk {
      caching              = "ReadWrite"
      storage_account_type = "Standard_LRS"
    }

    source_image_reference {
      publisher = "Canonical"
      offer     = "ubuntu-24_04-lts"
      sku       = "server"
      version   = "latest"
    }
  }