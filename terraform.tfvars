location = "East US 2"

rg_name                 = "rg-vnet"
vnet_name               = "vnet-eus2-prod"
vnet_address_space      = ["10.50.0.0/16"]
subnet_prefix           = "10.50.1.0/24"

tags = {
  environment = "prod"
  owner       = "platform"
}

virtual_hub_id = "/subscriptions/cea31a73-c42c-4b17-b83d-c629142bf942/resourceGroups/rg-eus2-fbe-prd-networking-001/providers/Microsoft.Network/virtualHubs/vwan-eus2-fbe-prd-hub-001"
