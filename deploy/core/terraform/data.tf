# Get current Azure client configuration
data "azurerm_client_config" "this" {}

# Lookup PostgreSQL Admin Group (non-blocking lookup)
data "azuread_groups" "postgresql_admin" {
  count = local.postgresql_admin_group_lookup_required ? 1 : 0

  display_names  = [var.postgresql_admin_group_name]
  ignore_missing = true
}

# Fallback PostgreSQL Admin User
data "azuread_user" "postgresql_admin_fallback" {
  count               = var.create_postgresql ? 1 : 0
  user_principal_name = var.postgresql_fallback_admin_user_principal_name
}

# Data Sources for Private DNS Zones in Hub Connectivity
data "azurerm_private_dns_zone" "hub" {
  for_each = local.private_link_dns_zones
  provider = azurerm.hub

  name                = each.value.zone_name
  resource_group_name = local.hub_dns_zone_resource_group
}

module "azure_region" {
  source  = "claranet/regions/azurerm"
  version = "8.0.4"

  azure_region = var.azure_location
}

data "azurerm_resources" "paired_region_pdns_zones" {
  for_each = var.create_acr_secondary_pe ? local.private_link_dns_zones : {}

  type                = "Microsoft.Network/privateDnsZones"
  name                = each.value.zone_name
  resource_group_name = var.paired_region_private_dns_zone_resource_group_name
}

data "azurerm_subnet" "paired_region_pe_subnet" {
  count = var.create_acr_secondary_pe ? 1 : 0

  name                 = var.paired_region_pe_subnet_name
  virtual_network_name = var.paired_region_vnet_name
  resource_group_name  = var.paired_region_vnet_resource_group_name
}

# look up the existing private DNS zone
data "azurerm_private_dns_zone" "aks_api_zone" {
  provider            = azurerm.hub
  name                = "privatelink.${var.azure_location}.azmk8s.io"
  resource_group_name = local.hub_dns_zone_resource_group
}

# =============================================================================
# AKS Cluster Data Source
# Derives the cluster name from module.aks.aks_cluster_id (a computed attribute).
# The resource ID is always (known after apply) on create, which defers
# this data source until the cluster actually exists.
# On day-2 plans, the ID is available from state → immediate read.
#
# Why not module.aks.aks_cluster_name?  The name is composed from inputs
# (including a random naming suffix).  If that random_string already lives in
# state from a prior partial apply, the name is known at plan time and the
# data source tries to read a cluster that doesn't exist yet → plan fails.
# This happened in UAT where the naming suffix was in state but AKS was not.
# =============================================================================
data "azurerm_kubernetes_cluster" "this" {
  name                = regex("[^/]+$", module.aks.aks_cluster_id)
  resource_group_name = module.resource_groups["aks"].name
}

data "azurerm_role_definition" "private_dns_zone_contributor" {
  name = "Private DNS Zone Contributor"
  # (no scope needed; this is a built-in role)
}
