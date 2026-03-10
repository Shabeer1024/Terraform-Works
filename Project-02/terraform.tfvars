admin_password = "D0n0t$hareit"
admin_username = "adam"

app_environment = {
    production={
        virtualnetworkname="vnet01"
        virtualnetworkcidrblock = "10.0.0.0/16"
subnets = {
    frontend01 = {cidrblock="10.0.0.0/24"
machine = {
WebDC01={
    natworkinterfacename = "frontend-nic"
    publicipaddressname  = "frontend-pip"
    }
    }
    }
    backend01  = {cidrblock="10.0.1.0/24"
machine = {
appDC01={
    natworkinterfacename = "backend-nic"
    publicipaddressname  = "backend-pip"
    }    
    }
    }
}
}
}