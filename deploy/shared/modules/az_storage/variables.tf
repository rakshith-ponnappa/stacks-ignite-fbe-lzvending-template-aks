variable "resource_group_name" {
  description = "The name of the resource group where the storage account will be created."
  type        = string
}

variable "location" {
  description = "The Azure region where the storage account will be created."
  type        = string
}

variable "storageaccount_name" {
  description = "The name of the storage account."
  type        = string
}

variable "resource_tags" {
  description = "A map of tags to assign to the resources."
  type        = map(string)
  default     = {}
}

# ------------------
# Storage Account Configuration
variable "storageaccount_account_tier" {
  description = "Defines the Tier to use for this storage account. Valid options are `Standard` and `Premium`."
  type        = string
  default     = "Standard"
}

variable "storageaccount_account_replication_type" {
  description = "Defines the type of replication to use for this storage account. Valid options are `LRS`, `GRS`, `RAGRS`, `ZRS`, `GZRS` and `RAGZRS`."
  type        = string
  default     = "GRS"
}

variable "storageaccount_account_kind" {
  description = "Defines the Kind of account. Valid options are `BlobStorage`, `BlockBlobStorage`, `FileStorage`, `Storage` and `StorageV2`."
  type        = string
  default     = "StorageV2"
}

variable "storageaccount_access_tier" {
  description = "Defines the access tier for `BlobStorage`, `FileStorage` and `StorageV2` accounts. Valid options are `Hot` and `Cool`."
  type        = string
  default     = "Hot"
}

variable "storageaccount_https_traffic_only_enabled" {
  description = "Boolean flag which forces HTTPS if enabled."
  type        = bool
  default     = true
}

variable "storageaccount_default_to_oauth_authentication" {
  description = "Default to Azure Active Directory authorization in the Azure portal when accessing the Storage Account."
  type        = bool
  default     = true
}

variable "storageaccount_infrastructure_encryption_enabled" {
  description = "Is infrastructure encryption enabled?"
  type        = bool
  default     = true
}

variable "storageaccount_allow_nested_items_to_be_public" {
  description = "Allow or disallow nested items within this Account to opt into being public."
  type        = bool
  default     = false
}

variable "storageaccount_cross_tenant_replication_enabled" {
  description = "Should cross Tenant replication be enabled?"
  type        = bool
  default     = false
}

variable "storageaccount_shared_access_key_enabled" {
  description = "Indicates whether the storage account permits requests to be authorized with the account access key via Shared Key."
  type        = bool
  default     = false
}

variable "storageaccount_min_tls_version" {
  description = "The minimum supported TLS version for the storage account."
  type        = string
  default     = "TLS1_2"
}

variable "storageaccount_network_rules" {
  description = "Network rules for the storage account."
  type = object({
    bypass                     = optional(set(string), ["AzureServices"])
    default_action             = optional(string, "Deny")
    ip_rules                   = optional(set(string), [])
    virtual_network_subnet_ids = optional(set(string), [])
    private_link_access = optional(list(object({
      endpoint_resource_id = string
      endpoint_tenant_id   = optional(string)
    })))
    timeouts = optional(object({
      create = optional(string)
      delete = optional(string)
      read   = optional(string)
      update = optional(string)
    }))
  })
  default = null
}

variable "storageaccount_nfsv3_enabled" {
  description = "Is NFSv3 protocol enabled?"
  type        = bool
  default     = false
}

variable "storageaccount_public_network_access_enabled" {
  description = "Whether the public network access is enabled."
  type        = bool
  default     = false
}

# ------------------
# Private Endpoints Configuration
variable "storageaccount_private_endpoints" {
  description = "Private endpoints configuration for the storage account."
  type = map(object({
    name                            = string
    subnet_resource_id              = string
    subresource_name                = string
    private_dns_zone_resource_ids   = optional(list(string), [])
    private_service_connection_name = optional(string)
    network_interface_name          = optional(string)
    tags                            = optional(map(string), {})
  }))
  default = {}
}

variable "storageaccount_private_endpoints_manage_dns_zone_group" {
  description = "Whether private DNS zone groups for private endpoints are managed by this module."
  type        = bool
  default     = true
}

# ------------------
# Storage Management Policy Rules
variable "storageaccount_management_policy_rules" {
  description = "Storage management policy rules for lifecycle management."
  type = map(object({
    enabled = optional(bool, true)
    name    = string
    actions = object({
      base_blob = optional(object({
        delete_after_days_since_modification_greater_than          = optional(number)
        tier_to_cool_after_days_since_modification_greater_than    = optional(number)
        tier_to_archive_after_days_since_modification_greater_than = optional(number)
      }))
      snapshot = optional(object({
        delete_after_days_since_creation_greater_than = optional(number)
      }))
      version = optional(object({
        delete_after_days_since_creation = optional(number)
      }))
    })
    filters = object({
      blob_types   = set(string)
      prefix_match = optional(set(string))
    })
  }))
  default = {}
}

variable "storageaccount_allowed_copy_scope" {
  description = "Restrict copy to and from Storage Accounts. Possible values are 'AAD' and 'PrivateLink'."
  type        = string
  default     = "AAD"
}

variable "storageaccount_queue_encryption_key_type" {
  description = "The encryption type of the queue service. Possible values are 'Service' and 'Account'."
  type        = string
  default     = "Account"
}

variable "storageaccount_table_encryption_key_type" {
  description = "The encryption type of the table service. Possible values are 'Service' and 'Account'."
  type        = string
  default     = "Account"
}

variable "storageaccount_blob_properties" {
  description = "Blob service properties including retention policies."
  type = object({
    change_feed_enabled           = optional(bool)
    change_feed_retention_in_days = optional(number)
    default_service_version       = optional(string)
    last_access_time_enabled      = optional(bool)
    versioning_enabled            = optional(bool, true)
    container_delete_retention_policy = optional(object({
      enabled = optional(bool, true)
      days    = optional(number, 7)
    }), {})
    delete_retention_policy = optional(object({
      enabled                  = optional(bool, true)
      days                     = optional(number, 7)
      permanent_delete_enabled = optional(bool, false)
    }), {})
  })
  default = {
    container_delete_retention_policy = {
      enabled = true
      days    = 7
    }
    delete_retention_policy = {
      enabled = true
      days    = 7
    }
  }
}

variable "enable_module_telemetry" {
  description = "This variable controls whether or not telemetry is enabled for the module. For more information see <https://aka.ms/avm/telemetryinfo>. If it is set to false, then no telemetry will be collected. "
  type        = bool
  sensitive   = false
  default     = false
}

variable "storage_account_private_endpoints_manage_dns_zone_group" {
  description = "Whether to manage private DNS zone groups with this module. If set to false, you must manage private DNS zone groups externally, e.g. using Azure Policy."
  type        = bool
  default     = false
}


variable "storageaccount_local_user_enabled" {
  description = "Whether local user access is enabled for the Storage Account. Should be false unless specifically required."
  type        = bool
  default     = false
}

variable "storageaccount_queue_properties" {
  description = "Queue service properties including logging configuration. Logging must be enabled for read, write and delete requests."
  type = object({
    logging = optional(object({
      delete                = optional(bool, true)
      read                  = optional(bool, true)
      write                 = optional(bool, true)
      version               = optional(string, "1.0")
      retention_policy_days = optional(number, 7)
    }), {})
  })
  default = {
    logging = {
      delete                = true
      read                  = true
      write                 = true
      version               = "1.0"
      retention_policy_days = 7
    }
  }
}

variable "storageaccount_share_properties" {
  description = "File share properties including retention policy for soft-delete."
  type = object({
    retention_policy = optional(object({
      days = optional(number, 7)
    }), {})
  })
  default = {
    retention_policy = {
      days = 7
    }
  }
}
