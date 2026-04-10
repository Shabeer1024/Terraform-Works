variable "firewall_policy_name" {
  type        = string
  description = "Name of the firewall policy"
}

variable "rule_collection_group_name" {
  type        = string
  description = "Name of the rule collection group"
  default     = "rcg-default"
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "sku" {
  type    = string
  default = "Standard"
}

variable "threat_intel_mode" {
  type    = string
  default = "Alert"
}

variable "trusted_networks" {
  type    = list(string)
  default = ["10.0.0.0/8"]
}

variable "allowed_mgmt_ips" {
  type    = list(string)
  default = []
}

variable "firewall_public_ip" {
  type    = string
  default = ""
}

variable "jumpbox_private_ip" {
  type    = string
  default = ""
}

variable "lion_dc2_private_ip" {
  type    = string
  default = ""
}

variable "tags" {
  type    = map(string)
  default = {}
}






