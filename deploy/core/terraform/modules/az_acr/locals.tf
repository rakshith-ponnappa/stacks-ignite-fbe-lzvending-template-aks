locals {
  # Determine SKU - Premium is required for geo-replication
  acr_sku = length(var.geo_redundant_regions) > 0 ? "Premium" : var.acr_sku

  # Zone redundancy is only available for Premium SKU
  zone_redundancy_enabled = local.acr_sku == "Premium" ? true : false

  # Network rule bypass option
  network_rule_bypass_option = var.public_network_access_enabled || var.network_rule_set == null ? null : "AzureServices"

  # Retention policy in days
  retention_policy_in_days = var.retention_policy_enabled ? (
    local.acr_sku == "Premium" ? var.retention_policy_in_days : var.default_retention_policy_in_days
  ) : var.default_retention_policy_in_days

  # Private endpoints configuration - merge primary and optional secondary
  private_endpoints = merge(
    {
      hub = {
        name                          = var.private_endpoint_name
        private_dns_zone_resource_ids = var.private_dns_zone_resource_ids
        subnet_resource_id            = var.private_endpoint_subnet_id
      }
    },
    var.create_acr_secondary_pe ? {
      hub_secondary = {
        name                          = var.private_endpoint_secondary_name
        location                      = var.secondary_pe_location
        private_dns_zone_resource_ids = var.secondary_private_dns_zone_resource_ids
        subnet_resource_id            = var.secondary_private_endpoint_subnet_id
      }
    } : {}
  )

  # Geo-replication configuration
  georeplications = length(var.geo_redundant_regions) > 0 ? [
    for region in var.geo_redundant_regions : {
      location                = region
      zone_redundancy_enabled = local.zone_redundancy_enabled
      tags                    = var.resource_tags
    }
  ] : []
}
