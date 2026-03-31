variable "log_analytics_workspace_name" {
  description = "The name of the Log analytics workspace resource"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group where resources will be created"
  type        = string
}

variable "resource_group_location" {
  description = "The location/region where resources will be created"
  type        = string
}

variable "log_analytics_sku" {
  description = "The SKU of the Log Analytics Workspace."
  type        = string
  default     = "PerGB2018"
}

variable "log_analytics_retention_in_days" {
  description = "The data retention in days."
  type        = number
  default     = 30
}

variable "log_analytics_daily_quota_gb" {
  description = "The daily quota limit, when this is reached no more data ingestion until the quota is reset at midnight. `null` = no limit"
  type        = number
  default     = null
}

variable "log_analytics_internet_ingestion_enabled" {
  description = "Should the Log Analytics Workspace support ingestion over the Public Internet"
  type        = bool
  default     = false
}

variable "resource_tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
  default     = {}
}
