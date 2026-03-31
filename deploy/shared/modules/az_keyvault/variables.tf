#------------------------------------------------------------------------------
# REQUIRED VARIABLES
#------------------------------------------------------------------------------

variable "keyvault_name" {
  type        = string
  description = "The name of the Key Vault. Must be globally unique."
}

variable "location" {
  type        = string
  description = "The Azure region where the Key Vault will be created."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group."
}

variable "tenant_id" {
  type        = string
  description = "The Azure AD tenant ID for the Key Vault."
}

#------------------------------------------------------------------------------
# SKU
#------------------------------------------------------------------------------

variable "sku_name" {
  type        = string
  default     = "standard"
  description = "The SKU of the Key Vault. Possible values are 'standard' or 'premium'."

  validation {
    condition     = contains(["standard", "premium"], var.sku_name)
    error_message = "SKU must be 'standard' or 'premium'."
  }
}

#------------------------------------------------------------------------------
# SECURITY SETTINGS
#------------------------------------------------------------------------------

variable "public_network_access_enabled" {
  type        = bool
  default     = false
  description = "Whether public network access is enabled. Should be false for production."
}

variable "purge_protection_enabled" {
  type        = bool
  default     = true
  description = "Whether purge protection is enabled. Recommended for production."
}

variable "soft_delete_retention_days" {
  type        = number
  default     = 90
  description = "The number of days to retain soft-deleted keys. Valid range: 7-90."

  validation {
    condition     = var.soft_delete_retention_days >= 7 && var.soft_delete_retention_days <= 90
    error_message = "Soft delete retention must be between 7 and 90 days."
  }
}

variable "enabled_for_deployment" {
  type        = bool
  default     = false
  description = "Whether Azure VMs can retrieve certificates from the Key Vault."
}

variable "enabled_for_disk_encryption" {
  type        = bool
  default     = false
  description = "Whether Azure Disk Encryption can retrieve secrets and unwrap keys."
}

variable "enabled_for_template_deployment" {
  type        = bool
  default     = false
  description = "Whether Azure Resource Manager can retrieve secrets from the Key Vault."
}

#------------------------------------------------------------------------------
# NETWORK ACLS
#------------------------------------------------------------------------------

variable "network_acls" {
  type = object({
    bypass                     = optional(string, "AzureServices")
    default_action             = optional(string, "Deny")
    ip_rules                   = optional(list(string), [])
    virtual_network_subnet_ids = optional(list(string), [])
  })
  default = {
    default_action = "Deny"
    bypass         = "AzureServices"
  }
  description = "Network ACL configuration for the Key Vault."
}

#------------------------------------------------------------------------------
# PRIVATE ENDPOINTS
#------------------------------------------------------------------------------

variable "private_endpoints" {
  type = map(object({
    name                            = optional(string)
    subnet_resource_id              = string
    private_dns_zone_resource_ids   = optional(set(string), [])
    private_dns_zone_group_name     = optional(string, "default")
    private_service_connection_name = optional(string)
    network_interface_name          = optional(string)
    location                        = optional(string)
    resource_group_name             = optional(string)
    tags                            = optional(map(string))
  }))
  default     = {}
  description = "Private endpoints configuration for the Key Vault."
}

#------------------------------------------------------------------------------
# ROLE ASSIGNMENTS
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
  description = "Role assignments for the Key Vault."
}

#------------------------------------------------------------------------------
# TAGS & TELEMETRY
#------------------------------------------------------------------------------

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to apply to the Key Vault."
}

variable "enable_telemetry" {
  type        = bool
  default     = false
  description = "Whether to enable AVM telemetry."
}
