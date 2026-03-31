#------------------------------------------------------------------------------
# Key Vault Module (AVM Wrapper)
# Provides secure secret, key, and certificate storage
#------------------------------------------------------------------------------

module "keyvault" {
  source  = "Azure/avm-res-keyvault-vault/azurerm"
  version = "0.10.2"

  # Required
  name                = var.keyvault_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tenant_id           = var.tenant_id

  # SKU
  sku_name = var.sku_name

  # Security Settings
  public_network_access_enabled   = var.public_network_access_enabled
  purge_protection_enabled        = var.purge_protection_enabled
  soft_delete_retention_days      = var.soft_delete_retention_days
  enabled_for_deployment          = var.enabled_for_deployment
  enabled_for_disk_encryption     = var.enabled_for_disk_encryption
  enabled_for_template_deployment = var.enabled_for_template_deployment

  # Network ACLs
  network_acls = var.network_acls

  # Private Endpoints
  private_endpoints = var.private_endpoints

  private_endpoints_manage_dns_zone_group = false

  # Role Assignments
  role_assignments = var.role_assignments

  # Tags & Telemetry
  tags             = var.tags
  enable_telemetry = var.enable_telemetry
}
