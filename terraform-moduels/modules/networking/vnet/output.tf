output "virtual_network_interfaces_ids" {
  value = azurerm_network_interface.Network_Interface[*].id
}

output "public_ip_addresses" {
  value = azurerm_public_ip.Public_Ipaddress[*].ip_address
}

output "virtual_network_id" {
  value = azurerm_virtual_network.Vnet01.id
}

output "network_interface_private_ip_address" {
  value = azurerm_network_interface.Network_Interface[*].private_ip_address
}



