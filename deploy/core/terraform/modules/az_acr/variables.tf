variable "resource_group_name" {
  description = "The name of the resource group where resources will be created"
  type        = string
}

variable "resource_group_location" {
  description = "The location/region where resources will be created"
  type        = string
}

variable "create_acr_registry" {
  description = "Whether to create the Azure Container Registry"
  type        = bool
  default     = true
}

variable "acr_name" {
  description = "The name of the Azure Container Registry"
  type        = string
}

variable "acr_sku" {
  description = "The SKU of the Azure Container Registry (Basic, Standard, Premium)"
  type        = string
  default     = "Premium"
}

variable "public_network_access_enabled" {
  description = "Whether public network access is enabled for the ACR"
  type        = bool
  default     = false
}

variable "retention_policy_enabled" {
  description = "Whether retention policy is enabled for the ACR"
  type        = bool
  default     = true
}

variable "retention_policy_in_days" {
  description = "The number of days to retain untagged manifests"
  type        = number
  default     = 7
}

variable "default_retention_policy_in_days" {
  description = "The default retention policy in days when retention policy is disabled"
  type        = number
  default     = 7
}

variable "geo_redundant_regions" {
  description = "List of regions for geo-replication"
  type        = list(string)
  default     = []
}

variable "network_rule_set" {
  description = "Network rule set configuration for the ACR"
  type = object({
    default_action = optional(string, "Deny")
    ip_rules = optional(list(object({
      ip_range = string
    })), [])
  })
  default = null
}

variable "private_endpoint_name" {
  description = "The name of the primary private endpoint"
  type        = string
}

variable "private_dns_zone_resource_ids" {
  description = "List of private DNS zone resource IDs for the primary private endpoint"
  type        = list(string)
}

variable "private_endpoint_subnet_id" {
  description = "The subnet resource ID for the primary private endpoint"
  type        = string
}

variable "create_acr_secondary_pe" {
  description = "Whether to create a secondary private endpoint for the ACR"
  type        = bool
  default     = false
}

variable "private_endpoint_secondary_name" {
  description = "The name of the secondary private endpoint"
  type        = string
  default     = null
}

variable "secondary_pe_location" {
  description = "The location for the secondary private endpoint"
  type        = string
  default     = null
}

variable "secondary_private_dns_zone_resource_ids" {
  description = "List of private DNS zone resource IDs for the secondary private endpoint"
  type        = list(string)
  default     = []
}

variable "secondary_private_endpoint_subnet_id" {
  description = "The subnet resource ID for the secondary private endpoint"
  type        = string
  default     = null
}

variable "resource_tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
  default     = {}
}
