#------------------------------------------------------------------------------
# REQUIRED VARIABLES
#------------------------------------------------------------------------------

variable "postgresql_server_name" {
  type        = string
  description = "Name of the PostgreSQL Flexible Server"
}

variable "location" {
  type        = string
  description = "Azure region for deployment"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}

variable "tenant_id" {
  type        = string
  description = "Azure AD tenant ID for Entra authentication"
}

variable "ad_administrators" {
  type = map(object({
    tenant_id      = string
    object_id      = string
    principal_name = string
    principal_type = string # "Group", "User", or "ServicePrincipal"
  }))
  description = "Entra ID administrators for the PostgreSQL server"
}

#------------------------------------------------------------------------------
# NETWORKING - REQUIRED (VNet Integration or Private Endpoints)
#------------------------------------------------------------------------------

variable "delegated_subnet_id" {
  type        = string
  default     = null
  description = "Subnet ID for VNet integration (delegated to PostgreSQL). Mutually exclusive with private_endpoints."
}

variable "private_dns_zone_id" {
  type        = string
  default     = null
  description = "Private DNS zone ID for VNet integration. Required if using delegated_subnet_id."
}

#------------------------------------------------------------------------------
# COMPUTE & STORAGE
#------------------------------------------------------------------------------

variable "sku_name" {
  type        = string
  default     = "B_Standard_B2s"
  description = "SKU name (tier + size). Examples: B_Standard_B1ms, GP_Standard_D2s_v3, MO_Standard_E4s_v3"

  validation {
    condition     = can(regex("^(B_Standard_|GP_Standard_|MO_Standard_)", var.sku_name))
    error_message = "SKU must start with B_Standard_, GP_Standard_, or MO_Standard_"
  }
}

variable "storage_mb" {
  type        = number
  default     = 32768
  description = "Storage size in MB. Valid: 32768, 65536, 131072, 262144, 524288, 1048576, 2097152, 4194304, 8388608, 16777216, 33553408"

  validation {
    condition = contains([
      32768, 65536, 131072, 262144, 524288,
      1048576, 2097152, 4194304, 8388608,
      16777216, 33553408
    ], var.storage_mb)
    error_message = "Invalid storage_mb value"
  }
}

variable "storage_tier" {
  type        = string
  default     = null
  description = "Storage tier: P4, P6, P10, P15, P20, P30, P40, P50, P60, P70, P80"
}

variable "auto_grow_enabled" {
  type        = bool
  default     = true
  description = "Enable storage auto-grow"
}

variable "postgresql_version" {
  type        = string
  default     = "17"
  description = "PostgreSQL version: 12, 13, 14, 15, 16, 17, 18"

  validation {
    condition     = contains(["12", "13", "14", "15", "16", "17", "18"], var.postgresql_version)
    error_message = "PostgreSQL version must be 12, 13, 14, 15, 16, 17, or 18"
  }
}

#------------------------------------------------------------------------------
# HIGH AVAILABILITY
#------------------------------------------------------------------------------

variable "high_availability" {
  type = object({
    mode                      = string
    standby_availability_zone = optional(string)
  })
  default     = null
  description = "High availability config. mode: SameZone or ZoneRedundant"
}

variable "availability_zone" {
  type        = string
  default     = null
  description = "Availability zone for the primary server (1, 2, or 3)"
}

#------------------------------------------------------------------------------
# BACKUP
#------------------------------------------------------------------------------

variable "backup_retention_days" {
  type        = number
  default     = 7
  description = "Backup retention in days (7-35)"

  validation {
    condition     = var.backup_retention_days >= 7 && var.backup_retention_days <= 35
    error_message = "Backup retention must be between 7 and 35 days"
  }
}

variable "geo_redundant_backup_enabled" {
  type        = bool
  default     = false
  description = "Enable geo-redundant backups (recommended for production)"
}

#------------------------------------------------------------------------------
# MAINTENANCE
#------------------------------------------------------------------------------

variable "maintenance_window" {
  type = object({
    day_of_week  = optional(string, "0") # Sunday
    start_hour   = optional(number, 2)   # 2 AM
    start_minute = optional(number, 0)
  })
  default = {
    day_of_week  = "0"
    start_hour   = 2
    start_minute = 0
  }
  description = "Preferred maintenance window"
}

#------------------------------------------------------------------------------
# SECURITY - CUSTOMER MANAGED KEYS (Optional)
#------------------------------------------------------------------------------

variable "customer_managed_key" {
  type = object({
    key_vault_key_id                     = string
    geo_backup_key_vault_key_id          = optional(string)
    geo_backup_user_assigned_identity_id = optional(string)
    primary_user_assigned_identity_id    = optional(string)
  })
  default     = null
  description = "Customer managed key configuration for encryption at rest"
}

#------------------------------------------------------------------------------
# MANAGED IDENTITY
#------------------------------------------------------------------------------

variable "managed_identities" {
  type = object({
    system_assigned            = optional(bool, false)
    user_assigned_resource_ids = optional(set(string), [])
  })
  default     = {}
  description = "Managed identity configuration"
}

#------------------------------------------------------------------------------
# SERVER CONFIGURATION (PostgreSQL settings)
#------------------------------------------------------------------------------

variable "server_configuration" {
  type = map(object({
    name   = string
    config = string
  }))
  default     = {}
  description = "PostgreSQL server configuration parameters"
}

#------------------------------------------------------------------------------
# DATABASES (Optional - apps may create their own)
#------------------------------------------------------------------------------

variable "databases" {
  type = map(object({
    name      = string
    charset   = optional(string, "UTF8")
    collation = optional(string, "en_US.utf8")
    timeouts = optional(object({
      create = optional(string)
      delete = optional(string)
      read   = optional(string)
    }))
  }))
  default     = {}
  description = "Databases to create (optional - apps create their own via separate module)"
}

#------------------------------------------------------------------------------
# MONITORING
#------------------------------------------------------------------------------

variable "diagnostic_settings" {
  type = map(object({
    name                                     = optional(string)
    log_categories                           = optional(set(string), [])
    log_groups                               = optional(set(string), ["allLogs"])
    metric_categories                        = optional(set(string), ["AllMetrics"])
    log_analytics_destination_type           = optional(string, "Dedicated")
    workspace_resource_id                    = optional(string)
    storage_account_resource_id              = optional(string)
    event_hub_authorization_rule_resource_id = optional(string)
    event_hub_name                           = optional(string)
    marketplace_partner_resource_id          = optional(string)
  }))
  default     = {}
  description = "Diagnostic settings for Log Analytics, Storage, or Event Hub"
}

#------------------------------------------------------------------------------
# RESOURCE LOCK
#------------------------------------------------------------------------------

variable "lock" {
  type = object({
    kind = string
    name = optional(string)
  })
  default     = null
  description = "Resource lock: CanNotDelete or ReadOnly"
}

#------------------------------------------------------------------------------
# RBAC
#------------------------------------------------------------------------------

variable "role_assignments" {
  type = map(object({
    role_definition_id_or_name             = string
    principal_id                           = string
    description                            = optional(string)
    skip_service_principal_aad_check       = optional(bool, false)
    condition                              = optional(string)
    condition_version                      = optional(string)
    delegated_managed_identity_resource_id = optional(string)
    principal_type                         = optional(string)
  }))
  default     = {}
  description = "Role assignments for the PostgreSQL server"
}

#------------------------------------------------------------------------------
# TAGS & TELEMETRY
#------------------------------------------------------------------------------

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Resource tags"
}

variable "enable_telemetry" {
  type        = bool
  default     = false
  description = "Enable AVM telemetry"
}
