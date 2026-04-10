# modules/networking/app_gateway/main.tf

locals {
  frontend_port_name      = "frontend-port-80"
  frontend_ip_config_name = "frontend-ip-public"
  http_listener_name      = "listener-http"
  image_backend_pool_name = "ImageServerPool"
  video_backend_pool_name = "VideoServerPool"
  image_http_setting_name = "httpsetting-image"
  video_http_setting_name = "httpsetting-video"
  url_path_map_name       = "urlpathmap-d2click"
  routing_rule_name       = "rule-path-based"
}

resource "azurerm_application_gateway" "appgw" {
  name                = "appgw-d2click"
  resource_group_name = var.resource_group_name
  location            = var.location

  # ── SKU ──
  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }

  # ── Gateway Subnet ──
  gateway_ip_configuration {
    name      = "appgw-ip-config"
    subnet_id = var.appgw_subnet_id          # ✅ fixed from azurerm_subnet.appgw_subnet.id
  }

  # ── Frontend IP ──
  frontend_ip_configuration {
    name                 = local.frontend_ip_config_name
    public_ip_address_id = var.appgw_pip_id  # ✅ fixed from azurerm_public_ip.appgw_pip.id
  }

  # ── Frontend Port ──
  frontend_port {
    name = local.frontend_port_name
    port = 80
  }

  # ── Backend Pools ──
  backend_address_pool {
    name = local.image_backend_pool_name     # /images/*
  }

  backend_address_pool {
    name = local.video_backend_pool_name     # /videos/*
  }

  # ── Backend HTTP Settings ──
  backend_http_settings {
    name                  = local.image_http_setting_name
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 30
  }

  backend_http_settings {
    name                  = local.video_http_setting_name
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 30
  }

  # ── HTTP Listener ──
  http_listener {
    name                           = local.http_listener_name
    frontend_ip_configuration_name = local.frontend_ip_config_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Http"
  }

  # ── URL Path Map ──
  url_path_map {
    name                               = local.url_path_map_name
    default_backend_address_pool_name  = local.image_backend_pool_name  # fallback
    default_backend_http_settings_name = local.image_http_setting_name

    path_rule {
      name                       = "image-path-rule"
      paths                      = ["/images/*"]
      backend_address_pool_name  = local.image_backend_pool_name
      backend_http_settings_name = local.image_http_setting_name
    }

    path_rule {
      name                       = "video-path-rule"
      paths                      = ["/videos/*"]
      backend_address_pool_name  = local.video_backend_pool_name
      backend_http_settings_name = local.video_http_setting_name
    }
  }

  # ── Routing Rule (PathBasedRouting) ──
  request_routing_rule {
    name               = local.routing_rule_name
    rule_type          = "PathBasedRouting"     # ✅ changed from Basic
    http_listener_name = local.http_listener_name
    url_path_map_name  = local.url_path_map_name  # ✅ replaces backend_address_pool_name
    priority           = 100
  }

  enable_http2 = false
  fips_enabled = false
}

# ── NIC → Backend Pool Association ──
resource "azurerm_network_interface_application_gateway_backend_address_pool_association" "assoc" {
  count                 = length(var.nic_pool_mapping)
  network_interface_id  = var.network_interface_ids[var.nic_pool_mapping[count.index].nic_index]
  ip_configuration_name = "internal"
  backend_address_pool_id = tolist([
    for pool in azurerm_application_gateway.appgw.backend_address_pool
    : pool if pool.name == var.nic_pool_mapping[count.index].pool_name
  ])[0].id
}






