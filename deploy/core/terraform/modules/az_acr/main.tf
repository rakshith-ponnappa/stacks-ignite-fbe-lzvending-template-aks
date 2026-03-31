module "acr_registry" {
  count   = var.create_acr_registry ? 1 : 0
  source  = "Azure/avm-res-containerregistry-registry/azurerm"
  version = "0.4.0"

  name                          = var.acr_name
  location                      = var.resource_group_location
  resource_group_name           = var.resource_group_name
  sku                           = local.acr_sku
  public_network_access_enabled = var.public_network_access_enabled
  zone_redundancy_enabled       = local.zone_redundancy_enabled
  network_rule_bypass_option    = local.network_rule_bypass_option
  retention_policy_in_days      = local.retention_policy_in_days
  private_endpoints             = local.private_endpoints
  georeplications               = local.georeplications
  network_rule_set              = var.network_rule_set
  tags                          = var.resource_tags
}

# NOTE: Private DNS Zone Contributor role is assigned at subscription scope
# in fb-connectivity (private_dns_zone_contributor_spns variable)
# No need to assign it again here - it was causing 409 Conflict errors
