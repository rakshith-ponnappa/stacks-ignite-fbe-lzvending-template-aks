variable "location" {
  type        = string
  description = "Azure region"
}

variable "environment" {
  type        = string
  description = "Environment name"
}

variable "rg_name" {
  type        = string
  description = "Resource group for the new VNet"
}

variable "vnet_name" {
  type        = string
  description = "VNet name"
}

variable "vnet_address_space" {
  type        = list(string)
  description = "VNet CIDRs"
}

variable "subnet_prefix" {
  type        = string
  description = "Workload subnet CIDR"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply"
  default     = {}
}

variable "subscription_alias_name" {
  type        = string
  description = "Subscription alias"
}

variable "virtual_hub_id" {
  type        = string
  description = "The ID of the Virtual Hub to connect to"
}