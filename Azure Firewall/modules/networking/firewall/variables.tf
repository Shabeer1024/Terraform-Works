variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "firewall_subnet_id" {
   type = string
   description = "AzureFirewallSubnet ID from networking module"
}

variable "firewall_pip_id" {
    type =string
    description = "Standard Static Public IP ID for Firewall"
}

variable "firewall_policy_id" {
  type = string
}






