#------------------------------------------------------------------------------
# Front Door Outputs (consumed by app-orchestration deployments)
#------------------------------------------------------------------------------

output "frontdoor_profile_id" {
  value       = var.create_frontdoor ? module.frontdoor.frontdoor_id : null
  description = "The resource ID of the Azure Front Door profile"
}

output "frontdoor_profile_name" {
  value       = var.create_frontdoor ? module.frontdoor.frontdoor_name : null
  description = "The name of the Azure Front Door profile"
}

output "frontdoor_resource_group_name" {
  value       = var.create_frontdoor ? module.resource_groups["afd"].name : null
  description = "The resource group name where the Front Door profile is deployed"
}

output "frontdoor_sku_name" {
  value       = var.create_frontdoor ? var.frontdoor_sku_name : null
  description = "The SKU of the Azure Front Door profile"
}

output "pls_name" {
  value       = local.pls_name
  description = "The name of the Private Link Service created by AKS App Routing"
}

output "aks_resource_group_name" {
  value       = module.resource_groups["aks"].name
  description = "The resource group name for the AKS cluster"
}

output "aks_cluster_name" {
  value       = module.aks.aks_cluster_name
  description = "The name of the AKS cluster"
}

output "aks_cluster_id" {
  value       = module.aks.aks_cluster_id
  description = "The resource ID of the AKS cluster"
}

output "private_endpoint_subnet_id" {
  value       = module.network.subnets["subn-privateendpoint-1"].resource_id
  description = "Subnet resource ID used for private endpoints in the core virtual network"
}

#------------------------------------------------------------------------------
# PostgreSQL Outputs (for app modules via remote state)
#------------------------------------------------------------------------------

output "postgresql_server_id" {
  value       = var.create_postgresql ? module.postgresql[0].postgresql_server_id : null
  description = "PostgreSQL Flexible Server resource ID"
}

output "postgresql_server_name" {
  value       = var.create_postgresql ? module.postgresql[0].postgresql_server_name : null
  description = "PostgreSQL Flexible Server name"
}

output "postgresql_server_fqdn" {
  value       = var.create_postgresql ? module.postgresql[0].postgresql_server_fqdn : null
  description = "Fully qualified domain name of the PostgreSQL server"
}

output "postgresql_connection_info" {
  value       = var.create_postgresql ? module.postgresql[0].postgresql_connection_info : null
  description = "Connection information for applications"
}

#------------------------------------------------------------------------------
# Key Vault Outputs (for app modules via remote state)
#------------------------------------------------------------------------------

output "keyvault_id" {
  value       = var.create_keyvault ? module.keyvault[0].keyvault_id : null
  description = "Key Vault resource ID"
}

output "keyvault_name" {
  value       = var.create_keyvault ? module.keyvault[0].keyvault_name : null
  description = "Key Vault name"
}

output "keyvault_uri" {
  value       = var.create_keyvault ? module.keyvault[0].keyvault_uri : null
  description = "Key Vault URI"
}

#------------------------------------------------------------------------------
# ACR Outputs (for app modules via remote state)
#------------------------------------------------------------------------------

output "acr_name" {
  value       = module.acr.acr_name
  description = "The name of the Azure Container Registry"
}

output "acr_id" {
  value       = module.acr.acr_id
  description = "The resource ID of the Azure Container Registry"
}

output "acr_login_server" {
  value       = module.acr.acr_login_server
  description = "The login server URL of the Azure Container Registry"
}

output "acr_resource_group_name" {
  value       = module.acr.acr_resource_group_name
  description = "The resource group name for the Azure Container Registry"
}

#------------------------------------------------------------------------------
# AGIC (Application Gateway Ingress Controller) Outputs
#------------------------------------------------------------------------------

output "agic_enabled" {
  value       = var.enable_agic
  description = "Whether the AGIC addon is enabled on the AKS cluster"
}

output "ingress_application_gateway" {
  value       = var.enable_agic ? module.aks.ingress_application_gateway : null
  description = "The AKS cluster's AGIC Application Gateway details (name, ID, identity)"
}

output "application_gateway_id" {
  value       = var.enable_agic ? azurerm_application_gateway.agic[0].id : null
  description = "The ID of the Terraform-managed Application Gateway used by AGIC"
}

output "application_gateway_name" {
  value       = var.enable_agic ? azurerm_application_gateway.agic[0].name : null
  description = "The name of the Terraform-managed Application Gateway used by AGIC"
}

output "application_gateway_public_ip" {
  value       = var.enable_agic && !var.enable_agw_private_only ? azurerm_public_ip.agic[0].ip_address : null
  description = "The public IP address of the Application Gateway (null when private-only)"
}

#------------------------------------------------------------------------------
# Subnet CIDR Outputs (for app-level network policies via remote state)
#------------------------------------------------------------------------------

output "private_endpoint_subnet_cidr" {
  value       = var.vnet_subnets["subn-privateendpoint-1"].address_prefixes[0]
  description = "CIDR of the private endpoint subnet (ACR, Storage, Key Vault)"
}

output "postgresql_subnet_cidr" {
  value       = var.create_postgresql ? var.vnet_subnets["subn-postgresql"].address_prefixes[0] : null
  description = "CIDR of the PostgreSQL delegated subnet"
}

output "appgw_subnet_cidr" {
  value       = var.enable_agic ? var.vnet_subnets[var.agic_subnet_name].address_prefixes[0] : null
  description = "CIDR of the Application Gateway subnet (AGIC)"
}
