resource "azurerm_linux_virtual_machine" "Lion-DC" {
    count = var.virtual_machine_count
    name                = "Lion-DC${count.index+1}"
    resource_group_name = var.resource_group_name
    location            = var.location
    size                = "Standard_B2s"
    admin_username      = "adam"
    admin_password      = "DummyP@ssword123!"
    disable_password_authentication = false
    network_interface_ids = [
    var.virtual_network_interfaces_ids[count.index]
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

  data "local_file" "cloudinit" {
    filename = "./modules/compute/VirtualMachines/cloudinit"
  }




