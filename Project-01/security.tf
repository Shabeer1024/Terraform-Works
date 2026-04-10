  resource "azurerm_key_vault" "appvaultkey1024" {
  name                        = "appvaultkey1024"
  location                    = local.resource_location
  resource_group_name         = azurerm_resource_group.NetworkRG.name
  tenant_id                   = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  sku_name = "standard"
}

resource "azurerm_key_vault_secret" "vmpassword" {
  name         = "vmpassword"
  value        = var.admin_password
  key_vault_id = azurerm_key_vault.appvaultkey1024.id
}





