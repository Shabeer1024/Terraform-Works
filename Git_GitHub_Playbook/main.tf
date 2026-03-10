  resource "azurerm_resource_group" "NetworkRG" {
    name     = "NetworkRG"
    location = local.resource_location
  }