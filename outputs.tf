output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
}

output "vhub_connection_id" {
  value = azurerm_virtual_hub_connection.vhub_conn.id
}