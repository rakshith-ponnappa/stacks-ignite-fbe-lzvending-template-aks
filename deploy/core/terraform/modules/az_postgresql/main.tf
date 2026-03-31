#------------------------------------------------------------------------------
# PostgreSQL Flexible Server Module (AVM Wrapper)
# Authentication: Microsoft Entra ID Only - No password authentication
#------------------------------------------------------------------------------

module "postgresql" {
  source  = "Azure/avm-res-dbforpostgresql-flexibleserver/azurerm"
  version = "0.1.4"

  # Required
  name                = var.postgresql_server_name
  location            = var.location
  resource_group_name = var.resource_group_name

  # SKU & Compute
  sku_name     = var.sku_name
  storage_mb   = var.storage_mb
  storage_tier = var.storage_tier

  # Version
  server_version = var.postgresql_version

  # ============================================
  # AUTHENTICATION: ENTRA ID ONLY
  # ============================================
  authentication = {
    active_directory_auth_enabled = true
    password_auth_enabled         = false # NO PASSWORD AUTH
    tenant_id                     = var.tenant_id
  }

  # Entra ID Administrator(s)
  ad_administrator = var.ad_administrators

  # NOT USED with Entra-only auth
  administrator_login    = null
  administrator_password = null

  # ============================================
  # NETWORKING: PRIVATE ONLY (VNet Integration)
  # ============================================
  delegated_subnet_id = var.delegated_subnet_id
  private_dns_zone_id = var.private_dns_zone_id

  # NO PUBLIC ACCESS
  public_network_access_enabled = false

  # SECURE DEFAULT: No firewall rules (override AVM insecure default)
  firewall_rules = {}

  # ============================================
  # HIGH AVAILABILITY
  # ============================================
  high_availability = var.high_availability
  zone              = var.availability_zone

  # ============================================
  # BACKUP & GEO-REDUNDANCY
  # ============================================
  backup_retention_days        = var.backup_retention_days
  geo_redundant_backup_enabled = var.geo_redundant_backup_enabled

  # ============================================
  # MAINTENANCE
  # ============================================
  maintenance_window = var.maintenance_window

  # ============================================
  # STORAGE
  # ============================================
  auto_grow_enabled = var.auto_grow_enabled

  # ============================================
  # SECURITY - CUSTOMER MANAGED KEYS
  # ============================================
  customer_managed_key = var.customer_managed_key

  # ============================================
  # SERVER CONFIGURATION
  # ============================================
  server_configuration = var.server_configuration

  # ============================================
  # DATABASES (Optional - apps create their own)
  # ============================================
  databases = var.databases

  # ============================================
  # MONITORING
  # ============================================
  diagnostic_settings = var.diagnostic_settings

  # ============================================
  # RESOURCE LOCK
  # ============================================
  lock = var.lock

  # ============================================
  # RBAC
  # ============================================
  role_assignments = var.role_assignments

  # ============================================
  # MANAGED IDENTITY
  # ============================================
  managed_identities = var.managed_identities

  # ============================================
  # TAGS & TELEMETRY
  # ============================================
  tags             = var.tags
  enable_telemetry = var.enable_telemetry
}
