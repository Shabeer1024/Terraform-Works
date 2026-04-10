resource "azurerm_firewall_policy" "fw_policy" {
  name                     = var.firewall_policy_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  sku                      = var.sku
  threat_intelligence_mode = var.threat_intel_mode

  dns {
    proxy_enabled = true
  }
}

resource "azurerm_firewall_policy_rule_collection_group" "rcg" {
  name               = var.rule_collection_group_name
  firewall_policy_id = azurerm_firewall_policy.fw_policy.id
  priority           = 100

  #----------- Network Rules -----------
  network_rule_collection {
    name     = "nrc-vm-to-vm"
    priority = 100
    action   = "Allow"

    rule {
      name                  = "allow-dc1-to-dc2"
      protocols             = ["TCP", "UDP"]
      source_addresses      = ["10.0.0.0/24"]      # subnet0 Lion-DC1
      destination_addresses = ["10.0.1.0/24"]      # subnet1 Lion-DC2
      destination_ports     = ["*"]
    }

    rule {
      name                  = "allow-dc2-to-dc1"
      protocols             = ["TCP", "UDP"]
      source_addresses      = ["10.0.1.0/24"]      # subnet1 Lion-DC2
      destination_addresses = ["10.0.0.0/24"]      # subnet0 Lion-DC1
      destination_ports     = ["*"]
    }

    rule {
      name                  = "allow-dns"
      protocols             = ["UDP"]
      source_addresses      = ["10.0.0.0/24", "10.0.1.0/24"]
      destination_addresses = ["8.8.8.8", "8.8.4.4"]
      destination_ports     = ["53"]
    }

    rule {
      name                  = "allow-ntp"
      protocols             = ["UDP"]
      source_addresses      = ["10.0.0.0/24", "10.0.1.0/24"]
      destination_addresses = ["*"]
      destination_ports     = ["123"]
    }
  }

  #----------- Application Rules -----------
  application_rule_collection {
    name     = "arc-allow-linux-outbound"
    priority = 200
    action   = "Allow"

    rule {
      name             = "allow-linux-updates"
      source_addresses = ["10.0.0.0/24", "10.0.1.0/24"]
      protocols {
        type = "Https"
        port = 443
      }
      protocols {
        type = "Http"
        port = 80
      }
      destination_fqdns = [
        "*.ubuntu.com",
        "*.debian.org",
        "security.ubuntu.com",
        "archive.ubuntu.com",
        "*.azure.com",
        "*.microsoft.com"
      ]
    }
  }

  #----------- DNAT Rules — SSH Inbound -----------
  nat_rule_collection {
    name     = "dnat-ssh-inbound"
    priority = 300
    action   = "Dnat"

    rule {
      name                = "dnat-ssh-lion-dc1"
      protocols           = ["TCP"]
      source_addresses    = var.allowed_mgmt_ips
      destination_address = var.firewall_public_ip
      destination_ports   = ["22"]                 # SSH to Lion-DC1
      translated_address  = var.jumpbox_private_ip # Lion-DC1 private IP
      translated_port     = "22"
    }

    rule {
      name                = "dnat-ssh-lion-dc2"
      protocols           = ["TCP"]
      source_addresses    = var.allowed_mgmt_ips
      destination_address = var.firewall_public_ip
      destination_ports   = ["2222"]               # different port → DC2
      translated_address  = var.lion_dc2_private_ip
      translated_port     = "22"
    }
  }
}






