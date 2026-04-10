resource "azurerm_firewall" "firewall" {
  name                = "fw-hub-d2click"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"
  firewall_policy_id  = var.firewall_policy_id

  ip_configuration {
    name                 = "fw-ipconfig"
    subnet_id            = var.firewall_subnet_id
    public_ip_address_id = var.firewall_pip_id    # ✅ from variable, not local resource
  }
}






