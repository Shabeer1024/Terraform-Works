app_environment = {
    production={
        virtualnetworkname="vnet01"
        virtualnetworkcidrblock = "10.0.0.0/16"
subnets = {
    frontend01 = {cidrblock="10.0.0.0/24"}
    backend01  = {cidrblock="10.0.1.0/24"}
}
    natworkinterfacename = "frontend-nic"
    publicipaddressname  = "frontend-pip"
    virtualmachinename   = "lion-dc"
}
}