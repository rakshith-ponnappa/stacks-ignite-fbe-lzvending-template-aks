resource "azurerm_resource_group" "rg_vnet" {
  name     = var.rg_name
  location = var.location
  tags     = var.tags
}

resource "azurerm_resource_group" "rg_nw" {
  name     = "NetworkWatcherRG"
  location = var.location
  tags     = var.tags
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  address_space       = var.vnet_address_space
  location            = azurerm_resource_group.rg_vnet.location
  resource_group_name = azurerm_resource_group.rg_vnet.name
  tags                = var.tags
}

resource "azurerm_subnet" "workload" {
  name                 = "snet-workload"
  resource_group_name  = azurerm_resource_group.rg_vnet.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.subnet_prefix]
}

resource "azurerm_virtual_hub_connection" "vhub_conn" {
  name                      = "${var.vnet_name}-${var.subscription_alias_name}-${var.environment}-to-vhub"
  virtual_hub_id            = data.terraform_remote_state.prd_eastus2_connectivity.outputs.virtual_hub_resource_id #todo spn access to remote state?
  #virtual_hub_id            = var.virtual_hub_id
  remote_virtual_network_id = azurerm_virtual_network.vnet.id

  # internet_security_enabled = true

  # routing {
  #   associated_route_table_id = data.terraform_remote_state.core_network.outputs.default_route_table_id
  #   propagated_route_table {
  #     route_table_ids = [
  #       data.terraform_remote_state.core_network.outputs.default_route_table_id
  #     ]
  #     labels = ["default"]
  #   }
  # }
}
