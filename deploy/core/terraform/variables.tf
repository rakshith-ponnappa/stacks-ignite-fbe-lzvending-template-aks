# Naming
variable "lz_short_code" {
  description = "A short code for the LZ to use in naming of resources."
  type        = string
  sensitive   = false
}

variable "component_names" {
  description = "A list of component names which can be used in naming of resources used with different module calls."
  type        = set(string)
  sensitive   = false
}

variable "azure_location" {
  description = "The Azure location to target all resources."
  type        = string
  sensitive   = false

  validation {
    condition     = contains(["eastus2", "centralus"], var.azure_location)
    error_message = "azure_location must be one of: eastus2, centralus."
  }
}

##
variable "environment" {
  type        = string
  description = "Environment name"
}
##

variable "azure_resource_group_management_lock_level" {
  description = "(Optional) The management lock level to apply to resource groups."
  type        = string
  sensitive   = false
  default     = ""

  validation {
    condition = contains([
      "",
      "ReadOnly",
      "CanNotDelete"
    ], var.azure_resource_group_management_lock_level)
    error_message = "Possible values are 'ReadOnly' or 'CanNotDelete'."
  }
}


variable "vnet_address_space" {
  description = "The address space applied to the virtual network. You can supply more than one address space."
  type        = list(string)
  nullable    = false
}

variable "vnet_subnets" {
  description = "A map of subnets to create."
  type = map(object({
    name                                          = string
    address_prefixes                              = list(string)
    nsg_rule_names                                = list(string)
    default_outbound_access_enabled               = optional(bool, false)
    route_names                                   = optional(list(string), [])
    private_link_service_network_policies_enabled = optional(bool, true)
    delegation = optional(list(object({
      name = string
      service_delegation = object({
        name = string
      })
    })), [])
  }))
}

variable "vnet_nsg_rules" {
  description = "A map of NSG rules to create."
  type = map(object({
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
  }))
  default = {}
}

# =============================================================================
# Tagging Variables
# PascalCase naming is required by the fb-tagging module interface.
# Values are set in terraform.tfvars and apply to all resources.
# =============================================================================
variable "ProductDomain" {
  description = "Identifies the product group and associated development team."
  type        = string
  validation {
    condition = contains([
      "Buy",
      "Enterprise",
      "Architecture",
      "Move",
      "Retail",
      "Digital",
      "Know"
    ], var.ProductDomain)
    error_message = "ProductDomain must be one of: Buy, Enterprise, Architecture, Move, Retail, Digital, Know."
  }
}

variable "Application" {
  description = "Identifies the application related to the resource."
  type        = string
}

variable "ApplicationCode" {
  description = "Links the application to the approved application list."
  type        = string
}

variable "Environment" {
  description = "Product lifecycle stage."
  type        = string
  validation {
    condition = contains([
      "Development",
      "Test",
      "Production"
    ], var.Environment)
    error_message = "Environment must be one of: Development, Test, Production."
  }
}

variable "Role" {
  description = "Roles of service"
  type        = string
}

variable "Criticality" {
  description = "Denotes the importance of a service and availability requirement. E.g. Low (95%), Medium (99.5%), High (99.9%) and Critical (99.95%)"
  type        = string
  validation {
    condition = contains([
      "Low",
      "Medium",
      "High",
      "Critical"
    ], var.Criticality)
    error_message = "Criticality must be one of: Low, Medium, High, Critical."
  }
}

variable "CostCode" {
  description = "The cost allocation code or budget code associated with the resource."
  type        = string
}

variable "Owner" {
  description = "The business Owner of the Resource Group/Resource."
  type        = string
}

variable "CreatedOn" {
  description = "The date the ARM deployment for the resource occurred, for example “2019-08-27T16:30:10.7936410+01:00”. (The use of the UTC time zone is recommended for consistency)."
  type        = string
}

variable "CreatedBy" {
  description = "Email address of the engineer who provisioned the resource."
  type        = string
}

variable "Monitoring" {
  description = "The monitoring solution used."
  type        = string
}

# (ACR) Azure Container Registry Variables
variable "create_acr_registry" {
  description = "Whether to create the Azure Container Registry"
  type        = bool
  default     = true
}

variable "acr_sku" {
  description = "The SKU of the Azure Container Registry (Basic, Standard, Premium)"
  type        = string
  default     = "Premium"
}

variable "acr_public_network_access_enabled" {
  description = "Whether public network access is enabled for the ACR"
  type        = bool
  default     = false
}

variable "acr_retention_policy_enabled" {
  description = "Whether retention policy is enabled for the ACR"
  type        = bool
  default     = true
}

variable "acr_retention_policy_in_days" {
  description = "The number of days to retain untagged manifests"
  type        = number
  default     = 7
}

variable "acr_default_retention_policy_in_days" {
  description = "The default retention policy in days when retention policy is disabled"
  type        = number
  default     = 7
}

variable "acr_geo_redundant_regions" {
  description = "List of regions for geo-replication"
  type        = list(string)
  default     = []
}

variable "acr_network_rule_set" {
  description = "Network rule set configuration for the ACR"
  type = object({
    default_action = optional(string, "Deny")
    ip_rules = optional(list(object({
      ip_range = string
    })), [])
  })
  default = null
}

variable "create_acr_secondary_pe" {
  description = "Whether to create a secondary private endpoint for the ACR"
  type        = bool
  default     = false
}

variable "private_link_dns_zones" {
  description = "Map of private DNS zones"
  type = map(object({
    zone_name = string
  }))
  default = {
    acr = {
      zone_name = "privatelink.azurecr.io"
    }
    aks = {
      zone_name = "privatelink.{regionName}.azmk8s.io"
    }
    blob = {
      zone_name = "privatelink.blob.core.windows.net"
    }
    postgresql = {
      zone_name = "privatelink.postgres.database.azure.com"
    }
    keyvault = {
      zone_name = "privatelink.vaultcore.azure.net"
    }
  }
}

variable "paired_region_private_dns_zone_resource_group_name" {
  description = "The resource group name where the paired region private DNS zones are located"
  type        = string
  default     = null
}

variable "paired_region_pe_subnet_name" {
  description = "The subnet name for private endpoints in the paired region"
  type        = string
  default     = null
}

variable "paired_region_vnet_name" {
  description = "The VNet name in the paired region"
  type        = string
  default     = null
}

variable "paired_region_vnet_resource_group_name" {
  description = "The resource group name for the VNet in the paired region"
  type        = string
  default     = null
}

# (AFD) Azure Front Door Variables
variable "create_frontdoor" {
  description = "Whether to create the Azure Front Door"
  type        = bool
  default     = true
}

variable "frontdoor_sku_name" {
  description = "Specifies the SKU for this Azure CDN FrontDoor profile. Possible values include `Standard_AzureFrontDoor` and `Premium_AzureFrontDoor`."
  type        = string
  default     = "Premium_AzureFrontDoor"

  validation {
    condition = contains([
      "Standard_AzureFrontDoor",
      "Premium_AzureFrontDoor"
    ], var.frontdoor_sku_name)
    error_message = "Possible values are 'Standard_AzureFrontDoor' or 'Premium_AzureFrontDoor'."
  }
}

variable "frontdoor_response_timeout_seconds" {
  description = "Specifies the maximum response timeout in seconds. Possible values are between `16` and `240` seconds (inclusive)."
  type        = number
  default     = 120
}

variable "frontdoor_logs_destinations_ids" {
  description = "List of destination resource IDs for sending Front Door logs"
  type        = list(string)
  default     = []
}

variable "availability_zones" {
  description = "List of availability zones for AKS node pools"
  type        = list(string)
  default     = ["2", "3"] # Change as needed
}

variable "log_analytics_sku" {
  description = "The SKU of the Log Analytics Workspace."
  type        = string
  default     = "PerGB2018"

  validation {
    condition     = contains(["PerGB2018", "Free", "Standalone", "PerNode"], var.log_analytics_sku)
    error_message = "log_analytics_sku must be one of: PerGB2018, Free, Standalone, PerNode."
  }
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

variable "usr_np_min_count" {
  description = "The minimum number of nodes for the user node pool."
  type        = number
  default     = 1
}

variable "usr_np_max_count" {
  description = "The maximum number of nodes for the user node pool."
  type        = number
  default     = 1
}

variable "usr_np_node_count" {
  description = "Initial number of nodes for the user node pool."
  type        = number
  default     = 1
}

variable "sys_np_min_count" {
  description = "The minimum number of nodes for the system node pool."
  type        = number
  default     = 1
}

variable "sys_np_max_count" {
  description = "The maximum number of nodes for the system node pool."
  type        = number
  default     = 1
}

variable "sys_np_node_count" {
  description = "Initial number of nodes for the system node pool."
  type        = number
  default     = 1
}

variable "usr_np_node_vm_size" {
  description = "The VM size for the user node pool."
  type        = string
  default     = "Standard_D2ds_v5"
}

variable "sys_np_node_vm_size" {
  description = "The VM size for the system node pool."
  type        = string
  default     = "Standard_D2ds_v5"
}

variable "aks_azure_policy_enabled" {
  description = "Enable the Azure Policy add-on for AKS clusters."
  type        = bool
  default     = true
}

variable "aks_role_based_access_control_enabled" {
  description = "Enable Kubernetes RBAC on AKS."
  type        = bool
  default     = true
}

variable "aks_azure_rbac_enabled" {
  description = "Enable Azure RBAC integration for AKS."
  type        = bool
  default     = true
}

variable "aks_private_cluster_public_fqdn_enabled" {
  description = "Create a public FQDN for a private AKS API server."
  type        = bool
  default     = false
}

variable "aks_api_server_authorized_ip_ranges" {
  description = "Optional CIDR allow-list for AKS API server access."
  type        = set(string)
  default     = null
}

variable "create_aks_user_identity" {
  description = "Flag to create AKS user-assigned identity."
  type        = bool
  default     = true
}

variable "workload_identity_enabled" {
  description = "Enabling workload identity for aks cluster"
  type        = bool
  default     = true
}

variable "only_critical_addons_enabled" {
  description = <<-EOT
    (Optional) Enabling this option will taint the default (system) node pool with
    `CriticalAddonsOnly=true:NoSchedule` taint. Only Kubernetes system services can
    schedule on the system node pool. User workloads will only run on the user node pool.
    WARNING: Changing this forces a new node pool to be created.
  EOT
  type        = bool
  default     = true
}

variable "vnet_routes" {
  type = map(object({
    name                   = string
    address_prefix         = string
    next_hop_type          = string
    next_hop_in_ip_address = optional(string)
  }))
  default     = {}
  description = "(Optional) A map of route objects to create on the route table. "
}

variable "service_cidr" {
  description = "The service CIDR for the AKS cluster."
  type        = string
  default     = ""

}

variable "dns_service_ip" {
  description = "The DNS service IP for the AKS cluster."
  type        = string
  default     = ""
}

variable "network_policy" {
  description = "Network policy plugin for AKS. Set to 'azure' for Azure NPM or 'calico' for Calico. null disables network policies."
  type        = string
  default     = "azure"
}

# =============================================================================
# App Routing Ingress Variables (Replaces Helm NGINX)
# =============================================================================
variable "enable_private_link_ingress" {
  description = <<-EOT
    Whether to create an internal ingress controller with Private Link Service for Front Door connectivity.
    Uses kubectl_manifest (gavinbunney/kubectl) which supports single-apply — no phased deployment needed.
  EOT
  type        = bool
  default     = false
}

variable "ingress_subnet_name" {
  type        = string
  description = "Ingress subnet for internal load balancer"
  default     = "subn-system-node-1"
}

variable "ingress_private_endpoint" {
  type        = string
  default     = "subn-privateendpoint-1"
  description = "Private Link Service subnet for the Ingress"
}

# =============================================================================
# AGIC (Application Gateway Ingress Controller) Configuration
# =============================================================================
variable "enable_agic" {
  description = "Whether to enable the AGIC addon on AKS with a brown-field Application Gateway v2"
  type        = bool
  default     = false
}

variable "enable_agw_private_only" {
  description = <<-EOT
    Register the EnableApplicationGatewayNetworkIsolation feature flag on the subscription.
    This enables private-IP-only Application Gateway v2 deployments (no public IP required).
    Requires AGIC v1.7+ and subnet delegation to Microsoft.Network/applicationGateways.
    Docs: https://learn.microsoft.com/en-us/azure/application-gateway/application-gateway-private-deployment
  EOT
  type        = bool
  default     = false
}

variable "agic_subnet_name" {
  description = "The subnet name for the Application Gateway used by AGIC"
  type        = string
  default     = "subn-appgw-1"
}

variable "agic_zones" {
  description = "Availability zones for the Application Gateway and its public IP (zone-redundant)"
  type        = list(string)
  default     = ["1", "2", "3"]
}

variable "agic_enable_private_frontend" {
  description = "Enable private frontend IP on AppGw for internal-only ingress (use-private-ip annotation)"
  type        = bool
  default     = false
}

variable "agic_private_ip_address" {
  description = "Optional static private IP for AppGw private frontend. If null, derives host .10 from the AGIC subnet CIDR."
  type        = string
  default     = null
}

# =============================================================================
# Demo Application Configuration (for PLS testing)
# =============================================================================
variable "deploy_demo_app" {
  description = "Whether to deploy the demo application for testing App Routing ingress with PLS"
  type        = bool
  default     = false
}

variable "demo_app_hostname" {
  description = "Hostname for the demo app ingress, must match Front Door origin_host_header"
  type        = string
  default     = "demo-app.internal.fivebelow.com"
}

variable "aks_aad_server_app_id" {
  description = "The AKS AAD Server application ID."
  type        = string
  default     = "6dae42f8-4368-4678-94ff-3960e28e3630"
}

variable "azure_spn_client_secret" {
  description = "Client Secret for the Azure SPN"
  type        = string
  sensitive   = true
}

#------------------------------------------------------------------------------
# PostgreSQL Flexible Server
#------------------------------------------------------------------------------

variable "create_postgresql" {
  description = "Whether to create the PostgreSQL Flexible Server"
  type        = bool
  default     = true
}

variable "postgresql_admin_group_object_id" {
  type        = string
  description = "Optional object ID override for the Entra ID group. If null, object_id is resolved via data.azuread_group using postgresql_admin_group_name."
  default     = null
}

variable "postgresql_admin_group_name" {
  type        = string
  description = "Display name of the Entra ID group for PostgreSQL administrators"
  default     = null
}

variable "postgresql_fallback_admin_user_principal_name" {
  type        = string
  description = "Fallback Entra ID user principal name used when the PostgreSQL admin group lookup has no match."
}

variable "postgresql_admin_principal_type" {
  type        = string
  description = "Principal type for PostgreSQL Entra ID admin. This template uses Group-based administration."
  default     = "Group"
  validation {
    condition     = var.postgresql_admin_principal_type == "Group"
    error_message = "postgresql_admin_principal_type must be Group."
  }
}

variable "postgresql_sku_name" {
  type        = string
  default     = "B_Standard_B1ms"
  description = "PostgreSQL SKU name. Dev/Test: B_Standard_B1ms, Prod: GP_Standard_D4s_v3"
}

variable "postgresql_storage_mb" {
  type        = number
  default     = 32768
  description = "PostgreSQL storage size in MB (32768 = 32GB)"
}

variable "postgresql_version" {
  type        = string
  default     = "17"
  description = "PostgreSQL version (17 is current stable)"
}

variable "postgresql_backup_retention_days" {
  type        = number
  default     = 7
  description = "Backup retention days (7-35). Prod should use 35."
}

variable "postgresql_geo_redundant_backup_enabled" {
  type        = bool
  default     = false
  description = "Enable geo-redundant backups. Recommended for production."
}

variable "postgresql_high_availability" {
  type = object({
    mode                      = string
    standby_availability_zone = optional(string)
  })
  default     = null
  description = "High availability configuration. Set to { mode = 'ZoneRedundant', standby_availability_zone = '2' } for production."
}

variable "postgresql_availability_zone" {
  type        = string
  default     = null
  description = "Availability zone for primary server (1, 2, or 3). Required for production HA."
}

#------------------------------------------------------------------------------
# KEY VAULT VARIABLES
#------------------------------------------------------------------------------

variable "create_keyvault" {
  type        = bool
  default     = false
  description = "Whether to create a Key Vault resource."
}

variable "keyvault_sku" {
  type        = string
  default     = "standard"
  description = "The SKU of the Key Vault. Possible values are 'standard' or 'premium'."
}

variable "keyvault_purge_protection_enabled" {
  type        = bool
  default     = true
  description = "Whether purge protection is enabled. Recommended for production."
}

variable "keyvault_soft_delete_retention_days" {
  type        = number
  default     = 90
  description = "The number of days to retain soft-deleted keys (7-90)."
}

variable "keyvault_enabled_for_deployment" {
  type        = bool
  default     = false
  description = "Whether Azure VMs can retrieve certificates from the Key Vault."
}

variable "keyvault_enabled_for_disk_encryption" {
  type        = bool
  default     = false
  description = "Whether Azure Disk Encryption can retrieve secrets and unwrap keys."
}

variable "keyvault_enabled_for_template_deployment" {
  type        = bool
  default     = false
  description = "Whether Azure Resource Manager can retrieve secrets from the Key Vault."
}
