
resource_group_name = "NetworkRG"
location = "Central Us"
vnet_name = "vnet01"
vnet_address_prefix = "10.0.0.0/16"
vnet_subnet_count = 1
network_interface_count = 0
public_ip_address_interface = 0
virtual_machine_count = 0
network_security_rules =[
    {
        priority = 300
        destination_port_range = "22"
    },
    {
        priority = 310
        destination_port_range = "80"
    }
]