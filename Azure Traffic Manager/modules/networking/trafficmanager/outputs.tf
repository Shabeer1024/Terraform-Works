# output "webapp_id" {
#     value = value(azurerm_windows_web_app.webapp)[*].id
# }

output "webapp_id" {
  value = var.webapp_id       # ← was wrongly referencing azurerm_windows_web_app.webapp
}

output "traffic_manager_fqdn" {
  value = azurerm_traffic_manager_profile.TM-profile.fqdn
}






