rg_name                 = "rg-vnet"
vnet_name               = "vnet-eus2-prod"
vnet_address_space      = ["10.50.0.0/16"]
subnet_prefix           = "10.50.1.0/24"

remote_state_rg                 = "rg-fde-tfstate"
remote_state_storage_account    = "steefbeeus2contfstate"
remote_state_container          = "tfstate"
remote_state_key                = "connectivity/core"

tags = {
  environment = "prod"
  owner       = "platform"
}