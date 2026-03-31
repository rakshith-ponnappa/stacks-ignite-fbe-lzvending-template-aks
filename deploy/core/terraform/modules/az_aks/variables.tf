variable "service_cidr" {
  description = "The CIDR range used for the AKS Service CIDR"
  type        = string
  default     = null
}

variable "dns_service_ip" {
  description = "IP address within the Kubernetes service address range that will be used by cluster service discovery (kube-dns)"
  type        = string
  default     = null
}

variable "usr_np_node_count" {
  description = "Initial number of nodes"
  type        = number
  default     = null
}

variable "usr_np_node_vm_size" {
  description = "VM SKU for the AKS nodes"
  type        = string
  default     = null
}

variable "usr_np_min_count" {
  description = "Minimum number of nodes in the node pool"
  type        = number
  default     = null
}

variable "usr_np_max_count" {
  description = "Maximum number of nodes in the node pool"
  type        = number
  default     = null
}

variable "sys_np_node_count" {
  description = "Initial number of nodes"
  type        = number
  default     = null
}

variable "sys_np_node_vm_size" {
  description = "VM SKU for the AKS nodes"
  type        = string
  default     = null
}

variable "enable_auto_scaling" {
  description = "Enable autoscaling for the node pool"
  type        = bool
  default     = true
}

variable "sys_np_min_count" {
  description = "Minimum number of nodes in the node pool"
  type        = number
  default     = null
}

variable "sys_np_max_count" {
  description = "Maximum number of nodes in the node pool"
  type        = number
  default     = null
}

variable "prefix" {
  type        = string
  description = "DNS prefix for the AKS cluster."
  default     = "aks"
}

variable "kubernetes_version" {
  description = "Kubernetes version for AKS cluster"
  type        = string
  default     = "1.34" # Change as needed
}

variable "azure_policy_enabled" {
  description = "Enable Azure Policy Add-on for AKS."
  type        = bool
  default     = true
}

variable "identity_type" {
  description = "The identity type for the AKS cluster."
  type        = string
  default     = "UserAssigned"
}

variable "network_plugin" {
  description = "The network plugin to use for the AKS cluster."
  type        = string
  default     = "azure"
}

variable "network_policy" {
  description = "The network policy plugin to use. Set to 'azure' for Azure NPM or 'calico' for Calico. null disables network policies."
  type        = string
  default     = null
}

variable "os_sku" {
  description = "The OS SKU to use for the AKS cluster nodes."
  type        = string
  default     = "Ubuntu"
}

variable "os_disk_type" {
  description = "The OS disk type for the AKS cluster nodes."
  type        = string
  default     = "Ephemeral"
}

variable "os_type" {
  description = "The OS type for the AKS cluster nodes."
  type        = string
  default     = "Linux"
}

variable "os_disk_size_gb" {
  description = "The OS disk size for the AKS cluster nodes in GB."
  type        = number
  default     = 64
}

variable "node_pool_mode" {
  description = "The mode for the node pool."
  type        = string
  default     = "User"
}

variable "role_based_access_control_enabled" {
  type        = bool
  default     = true
  description = "Enable Role Based Access Control."
  nullable    = false
}

variable "api_server_authorized_ip_ranges" {
  description = "Optional set of CIDR ranges allowed to access the Kubernetes API server."
  type        = set(string)
  default     = null
}

variable "rbac_aad_azure_rbac_enabled" {
  type        = bool
  default     = true
  description = "(Optional) Is Role Based Access Control based on Azure AD enabled?"
}

variable "rbac_aad_admin_group_object_ids" {
  type        = list(string)
  default     = null
  description = "Object ID of groups with admin access."
}

variable "local_account_disabled" {
  description = "If true, local Kubernetes admin accounts will be disabled. Only Azure AD/Entra ID users will have access."
  type        = bool
  default     = true
}

variable "azure_location" {
  description = "The Azure location to target all resources."
  type        = string
  sensitive   = false
}

variable "resource_tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
  default     = {}
}

variable "resource_group_name" {
  description = "The name of the resource group where the AKS cluster will be deployed."
  type        = string
}

variable "node_resource_group" {
  description = "The name of the node resource group for the AKS cluster."
  type        = string
}

variable "cluster_name" {
  description = "The name of the AKS cluster."
  type        = string
}

variable "agents_pool_name" {
  description = "The name of the system node pool."
  type        = string
}

variable "temporary_name_for_rotation" {
  description = "Temporary name for node pool rotation."
  type        = string
}

variable "agents_availability_zones" {
  description = "List of availability zones for the system node pool."
  type        = list(string)
  default     = null
}

variable "pod_subnet_id" {
  description = "The ID of the subnet for pods."
  type        = string
}

variable "system_subnet_id" {
  description = "The ID of the subnet for system nodes."
  type        = string
}

variable "user_subnet_id" {
  description = "The ID of the subnet for user nodes."
  type        = string
}

variable "private_dns_zone_id" {
  description = "The ID of the private DNS zone for AKS."
  type        = string
}

variable "private_cluster_public_fqdn_enabled" {
  description = "Whether to create a public FQDN for the private AKS cluster API server."
  type        = bool
  default     = false
}

variable "user_pool_name" {
  description = "The name of the user node pool."
  type        = string
}

variable "user_pool_zones" {
  description = "List of availability zones for the user node pool."
  type        = list(string)
  default     = null
}

variable "attached_acr_id_map" {
  description = "Map of Azure Container Registry IDs to attach to the AKS cluster."
  type        = map(string)
  default     = {}
}

variable "log_analytics_workspace_id" {
  description = "The ID of the Log Analytics Workspace."
  type        = string
  default     = null
}

variable "log_analytics_workspace_name" {
  description = "The name of the Log Analytics Workspace."
  type        = string
  default     = null
}

variable "rbac_aad_tenant_id" {
  description = "The tenant ID for Azure AD RBAC."
  type        = string
}

variable "current_client_object_id" {
  description = "The object ID of the current client for RBAC."
  type        = string
}

# AKS User Assigned Managed Identity IDs
variable "create_aks_user_identity" {
  description = "Flag to create AKS user-assigned identity."
  type        = bool
  default     = false
}

variable "aks_user_identity_name" {
  description = "The name of the AKS user-assigned managed identity."
  type        = string
  default     = null
}

variable "private_dns_zone_contributor" {
  description = "Private DNS Zone Contributor role definition"
  type        = string
}

variable "aks_api_zone" {
  description = "The private DNS zone for AKS API"
  type        = string
}

variable "workload_identity_enabled" {
  description = "Enabling workload identity for aks cluster"
  type        = bool
}

# =============================================================================
# App Routing Configuration
# =============================================================================
variable "web_app_routing_enabled" {
  description = "Enable the Web App Routing (App Routing) add-on for AKS"
  type        = bool
  default     = false
}

variable "web_app_routing_dns_zone_ids" {
  description = "List of Azure DNS zone resource IDs for App Routing DNS integration"
  type        = list(string)
  default     = []
}

variable "default_nginx_controller" {
  description = <<-EOT
    Ingress type for the default NginxIngressController custom resource.
    Set to "None" to disable the default public NGINX controller when using
    custom internal controllers (e.g. for Front Door → PLS traffic flow).
    Allowed values: "None", "Internal", "External", "AnnotationControlled".
  EOT
  type        = string
  default     = "None"

  validation {
    condition     = contains(["None", "Internal", "External", "AnnotationControlled"], var.default_nginx_controller)
    error_message = "default_nginx_controller must be one of: None, Internal, External, AnnotationControlled."
  }
}

# =============================================================================
# System Node Pool Configuration
# =============================================================================
variable "only_critical_addons_enabled" {
  description = <<-EOT
    (Optional) Enabling this option will taint the default (system) node pool with
    `CriticalAddonsOnly=true:NoSchedule` taint. Only Kubernetes system services
    (CoreDNS, kube-proxy, metrics-server, etc.) can schedule on the system node pool.
    User workloads will only run on the user node pool.
    WARNING: Changing this forces a new node pool to be created.
  EOT
  type        = bool
  default     = null
}

# =============================================================================
# AGIC (Application Gateway Ingress Controller) Configuration
# =============================================================================
variable "brown_field_application_gateway_for_ingress" {
  description = <<-EOT
    Application Gateway Ingress Controller (AGIC) brown-field configuration.
    Uses an existing Application Gateway and enables the AGIC addon on AKS.
    Both id and subnet_id are required.
  EOT
  type = object({
    id        = string
    subnet_id = string
  })
  default = null
}
