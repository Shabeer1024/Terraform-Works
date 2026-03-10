


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

#-----------------------Network Interface ------------------

  resource "azurerm_network_interface" "frontinterface" {
    name                = var.app_environment.production.natworkinterfacename
    location            = local.resource_location
    resource_group_name = azurerm_resource_group.NetworkRG.name

    ip_configuration {
      name                          = "internal"
      subnet_id                     = azurerm_subnet.frontend01["frontend01"].id
      private_ip_address_allocation = "Dynamic"
      public_ip_address_id = azurerm_public_ip.pubip.id
    }
  }

  #---------------------Public Ip -----------------------

    resource "azurerm_public_ip" "pubip" {
    name                = var.app_environment.production.publicipaddressname
    resource_group_name = azurerm_resource_group.NetworkRG.name
    location            = local.resource_location
    allocation_method   = "Static"
  }

#-------------------- NSG app-nsg Rules----------------------------

  resource "azurerm_network_security_group" "app-nsg" {
    name                = "app-nsg"
    location            = local.resource_location
    resource_group_name = azurerm_resource_group.NetworkRG.name

    security_rule {
      name                       = "Allow_SSH"
      priority                   = 300
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
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
    name                = var.app_environment.production.virtualmachinename
    resource_group_name = azurerm_resource_group.NetworkRG.name
    location            = local.resource_location
    size                = "Standard_B2s"
    admin_username      = "adam"
    admin_password      = var.admin_password
    disable_password_authentication = false
    network_interface_ids = [
    azurerm_network_interface.frontinterface.id
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


