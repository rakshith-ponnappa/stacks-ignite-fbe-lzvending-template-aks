rg_name                 = "rg-vnet"
vnet_name               = "vnet-eus2-prod"
vnet_address_space      = ["10.50.0.0/16"]
subnet_prefix           = "10.50.1.0/24"

tags = {
  environment = "prod"
  owner       = "platform"
}