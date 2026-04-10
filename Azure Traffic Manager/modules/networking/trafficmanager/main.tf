# resource "azurerm_traffic_manager_profile" "TM-profile" {
#   resource_group_name = var.resource_group_name  
#   location = var.location
#   traffic_routing_method = "Weighted"

#   dns_config {
#     relative_name = "example-profile"
#     ttl           = 100
#   }

#   monitor_config {
#     protocol                     = "HTTPS"
#     port                         = 443
#     path                         = "/"
#     interval_in_seconds          = 30
#     timeout_in_seconds           = 9
#     tolerated_number_of_failures = 3
#   }
# }

# resource "azurerm_traffic_manager_azure_endpoint" "TM-Endpoint" {
#   for_each = var.traffic_manager_endpoints
#   name                 = each.key
#   profile_id           = azurerm_traffic_manager_profile.TM-profile.id
#   always_serve_enabled = true
#   priority = each.value.priority
#   weight               = each.value.weight
#   target_resource_id   = var.webapp_id[(each.value.priority)-1]

#   custom_header {
#     name = "host"
#     value = var.webapp_hostname[(each.value.priority)-1]
#   }
# }

resource "azurerm_traffic_manager_profile" "TM-profile" {
  name                   = var.traffic_manager_name        # ← required, was missing
  resource_group_name    = var.resource_group_name
  # location is NOT valid here — Traffic Manager is a global resource
  traffic_routing_method = "Weighted"

  dns_config {
    relative_name = "example-profile"
    ttl           = 100
  }

  monitor_config {
    protocol                     = "HTTPS"
    port                         = 443
    path                         = "/"
    interval_in_seconds          = 30
    timeout_in_seconds           = 9
    tolerated_number_of_failures = 3
  }
}

resource "azurerm_traffic_manager_azure_endpoint" "TM-Endpoint" {
  for_each             = var.traffic_manager_endpoints
  name                 = each.key
  profile_id           = azurerm_traffic_manager_profile.TM-profile.id
  always_serve_enabled = true
  priority             = each.value.priority
  weight               = each.value.weight
  target_resource_id   = var.webapp_id[(each.value.priority) - 1]

  custom_header {
    name  = "host"
    value = var.webapp_hostname[(each.value.priority) - 1]
  }
}








