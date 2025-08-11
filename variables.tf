variable "location" {
  type        = string
  description = "Azure region"
  default     = "East US 2"
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

variable "remote_state_rg" {
  type        = string
  description = "RG hosting the state storage account"
}
variable "remote_state_storage_account" {
  type        = string
  description = "State storage account name"
}
variable "remote_state_container" {
  type        = string
  description = "State container name"
}
variable "remote_state_key" {
  type        = string
  description = "Blob key for the other workspace's state (e.g. core-net/prod.tfstate)"
}