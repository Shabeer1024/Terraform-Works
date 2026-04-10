output "firewall_policy_id" {
  value       = azurerm_firewall_policy.fw_policy.id
  description = "ID of the firewall policy — attach to azurerm_firewall"
}

output "firewall_policy_name" {
  value = azurerm_firewall_policy.fw_policy.name
}






