module "aks" {
  source  = "Azure/aks/azurerm"
  version = "11.3.0"

  # Resource Group and Location
  resource_group_name = var.resource_group_name
  location            = var.azure_location
  node_resource_group = var.node_resource_group

  # Cluster Identification
  cluster_name       = var.cluster_name
  prefix             = var.prefix
  kubernetes_version = var.kubernetes_version

  # Monitoring and Access Control
  log_analytics_workspace_enabled   = true
  msi_auth_for_monitoring_enabled   = true
  azure_policy_enabled              = var.azure_policy_enabled
  oidc_issuer_enabled               = true
  role_based_access_control_enabled = var.role_based_access_control_enabled
  rbac_aad_azure_rbac_enabled       = var.rbac_aad_azure_rbac_enabled
  rbac_aad_admin_group_object_ids   = local.rbac_aad_admin_group_object_ids
  rbac_aad_tenant_id                = var.rbac_aad_tenant_id

  # Main Agent Pool Configuration
  agents_count                = var.sys_np_node_count
  agents_max_count            = var.sys_np_max_count
  agents_max_pods             = 100
  agents_min_count            = var.sys_np_min_count
  agents_pool_name            = var.agents_pool_name
  agents_size                 = var.sys_np_node_vm_size
  agents_availability_zones   = var.agents_availability_zones
  auto_scaling_enabled        = var.enable_auto_scaling
  os_sku                      = var.os_sku
  os_disk_type                = var.os_disk_type
  os_disk_size_gb             = var.os_disk_size_gb
  temporary_name_for_rotation = var.temporary_name_for_rotation
  host_encryption_enabled     = true

  # System node pool taint — only critical addons (CoreDNS, kube-proxy, etc.) can schedule here
  only_critical_addons_enabled = var.only_critical_addons_enabled

  # Networking Configuration
  pod_subnet = {
    id = var.pod_subnet_id
  }
  vnet_subnet = {
    id = var.system_subnet_id
  }
  private_cluster_enabled             = true
  private_cluster_public_fqdn_enabled = var.private_cluster_public_fqdn_enabled
  api_server_authorized_ip_ranges     = var.api_server_authorized_ip_ranges
  private_dns_zone_id                 = var.private_dns_zone_id

  # Additional Node Pools
  node_pools = {
    user_pool = {
      name                        = var.user_pool_name
      mode                        = var.node_pool_mode
      node_count                  = var.usr_np_node_count
      vm_size                     = var.usr_np_node_vm_size
      auto_scaling_enabled        = var.enable_auto_scaling
      os_sku                      = var.os_sku
      os_disk_type                = var.os_disk_type
      os_type                     = var.os_type
      os_disk_size_gb             = var.os_disk_size_gb
      min_count                   = var.usr_np_min_count
      max_count                   = var.usr_np_max_count
      pod_subnet                  = { id = var.pod_subnet_id }
      vnet_subnet                 = { id = var.user_subnet_id }
      temporary_name_for_rotation = var.temporary_name_for_rotation
      zones                       = var.user_pool_zones
      host_encryption_enabled     = true
    }
  }

  ## Local Account Disabled
  local_account_disabled = var.local_account_disabled

  # Identity and Networking
  identity_type  = var.identity_type
  identity_ids   = azurerm_user_assigned_identity.aks_identity[*].id
  network_plugin = var.network_plugin
  network_policy = var.network_policy

  # ACR Integration
  attached_acr_id_map = var.attached_acr_id_map

  # Workload identity
  workload_identity_enabled = var.workload_identity_enabled

  # Log Analytics Workspace
  log_analytics_workspace = local.log_analytics_workspace

  net_profile_service_cidr   = var.service_cidr
  net_profile_dns_service_ip = var.dns_service_ip
  net_profile_outbound_type  = "userDefinedRouting"

  # App Routing Add-on (managed NGINX ingress controller)
  web_app_routing = var.web_app_routing_enabled ? {
    dns_zone_ids             = var.web_app_routing_dns_zone_ids
    default_nginx_controller = var.default_nginx_controller
  } : null

  # AGIC (Application Gateway Ingress Controller) Add-on (brown-field)
  brown_field_application_gateway_for_ingress = var.brown_field_application_gateway_for_ingress

  # Disable AGIC role assignments — the AGIC addon auto-creates these
  # (Reader on RG, Contributor on AppGw, Network Contributor on VNet)
  # during brown-field provisioning. Terraform duplicates cause 409 conflicts.
  create_role_assignments_for_application_gateway = false

  # Tags
  tags = var.resource_tags

  depends_on = [
    azurerm_user_assigned_identity.aks_identity,
    time_sleep.wait_for_dns_zone_rbac,
  ]
}

resource "azurerm_user_assigned_identity" "aks_identity" {
  count               = var.create_aks_user_identity ? 1 : 0
  name                = var.aks_user_identity_name
  location            = var.azure_location
  resource_group_name = var.resource_group_name
  tags                = var.resource_tags
}

# Grant AKS control-plane UAI permissions on the zone
resource "azurerm_role_assignment" "aks_private_dns_zone" {
  scope              = var.aks_api_zone
  role_definition_id = var.private_dns_zone_contributor
  principal_id       = azurerm_user_assigned_identity.aks_identity[0].principal_id

  # Ignore changes to role_definition_id format (subscription-prefixed vs provider-prefixed)
  # to prevent unnecessary replacements that cause dependency cycles
  lifecycle {
    ignore_changes = [role_definition_id]
  }

  depends_on = [
    azurerm_user_assigned_identity.aks_identity
  ]
}

# =============================================================================
# Wait for RBAC to propagate before creating AKS cluster
# Azure role assignments can take 30s-5min to propagate. Without this wait,
# AKS creation races against DNS zone permission propagation and fails with:
#   ResourceMissingPermissionError: ...not allowed for action
#   Microsoft.Network/privateDnsZones/read
# =============================================================================
resource "time_sleep" "wait_for_dns_zone_rbac" {
  depends_on = [
    azurerm_role_assignment.aks_private_dns_zone,
    azurerm_role_assignment.aks_user_id_network_contributor,
  ]

  create_duration = "90s"
}

# Only created in East US 2 (primary region) since these are subscription-scoped
resource "azurerm_role_assignment" "aks_user_id_network_contributor" {
  count                = var.create_aks_user_identity ? 1 : 0
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.aks_identity[0].principal_id
  description          = "Grant Network Contributor role to AKS user identity"

  # Ignore changes to scope format to prevent unnecessary replacements
  lifecycle {
    ignore_changes = [scope]
  }
}

resource "azurerm_role_assignment" "aks_identity_cluster_admin_role" {
  scope                = module.aks.aks_id
  role_definition_name = "Azure Kubernetes Service RBAC Cluster Admin"
  principal_id         = var.current_client_object_id
}

resource "azurerm_role_assignment" "aks_nodepool_network_contributor" {
  scope              = data.azurerm_subscription.current.id
  principal_id       = data.azurerm_user_assigned_identity.aks_nodepool_network_contributor.principal_id
  role_definition_id = data.azurerm_role_definition.network_contributor.id

  skip_service_principal_aad_check = true

  # Ignore changes to prevent unnecessary replacements that cause dependency cycles
  lifecycle {
    ignore_changes = [scope, role_definition_id, principal_id]
  }

  depends_on = [
    azurerm_user_assigned_identity.aks_identity, module.aks, azurerm_role_assignment.aks_private_dns_zone
  ]
}
