module "az_naming" {
  source = "git::https://github.com/FiveB-Infra/fb-naming.git?ref=v2026.03.17.11"

  component_names    = var.component_names
  company_name_short = var.lz_short_code
  azure_location     = var.azure_location
  environment        = var.environment

}

module "tagging" {
  source = "git::https://github.com/FiveB-Infra/fb-tagging.git?ref=v2026.03.10.4"

  ProductDomain   = var.ProductDomain
  Application     = var.Application
  ApplicationCode = var.ApplicationCode
  Environment     = var.Environment
  Role            = var.Role
  Criticality     = var.Criticality
  CostCode        = var.CostCode
  Owner           = var.Owner
  CreatedOn       = var.CreatedOn
  CreatedBy       = var.CreatedBy
  Monitoring      = var.Monitoring
}

module "remote_state" {
  source = "../../shared/modules/tf_remote_state"

  workspace_name = "prd"
  remote_state_configs = {
    # Management remote states (provides AMPLS details for LAW linking)
    "management_eastus2" = {
      storage_account_name = "steus2manprdtfstatecig"
      container_name       = "tfstate"
      key                  = "management/core"
      use_azuread_auth     = true
    }
    "management_centralus" = {
      storage_account_name = "stcusmanprdtfstatejqp"
      container_name       = "tfstate"
      key                  = "management/core"
      use_azuread_auth     = true
    }

    # Connectivity remote states
    "connectivity_eastus2" = {
      storage_account_name = "steus2conprdtfstatewee"
      container_name       = "tfstate"
      key                  = "connectivity/core"
      use_azuread_auth     = true
    }
    "connectivity_centralus" = {
      storage_account_name = "stcusconprdtfstatensj"
      container_name       = "tfstate"
      key                  = "connectivity/core"
      use_azuread_auth     = true
    }
    # Identity remote states (provides domain_controller_private_ips for DNS)
    "identity_eastus2" = {
      storage_account_name = "steus2ideprdtfstatehe1"
      container_name       = "tfstate"
      key                  = "identity/core"
      use_azuread_auth     = true
    }
    "identity_centralus" = {
      storage_account_name = "stcusideprdtfstateaee"
      container_name       = "tfstate"
      key                  = "identity/core"
      use_azuread_auth     = true
    }
  }
}

# =============================================================================
# Subscription Feature Registration
# Enables private-IP-only Application Gateway v2 deployments (no public IP required)
# Docs: https://learn.microsoft.com/en-us/azure/application-gateway/application-gateway-private-deployment
# =============================================================================
resource "azapi_resource_action" "agw_network_isolation" {
  count = var.enable_agw_private_only ? 1 : 0

  type        = "Microsoft.Network/features@2021-07-01"
  resource_id = "/subscriptions/${data.azurerm_client_config.this.subscription_id}/providers/Microsoft.Features/providers/Microsoft.Network/features/EnableApplicationGatewayNetworkIsolation"
  action      = "register"
  method      = "POST"
}

# Wait for feature registration to propagate (Registering â†’ Registered).
# Feature registration typically takes 2-3 minutes. Using time_sleep instead
# of az CLI polling because local-exec does not inherit Terraform provider
# auth (SPN env vars) - az CLI would need a separate login, which differs
# across CI runners and auth methods (SPN, OIDC, managed identity).
resource "time_sleep" "wait_for_agw_network_isolation" {
  count = var.enable_agw_private_only ? 1 : 0

  create_duration = "300s"

  depends_on = [azapi_resource_action.agw_network_isolation]
}

module "resource_groups" {
  source  = "Azure/avm-res-resources-resourcegroup/azurerm"
  version = "0.2.1"

  for_each = var.component_names

  location = var.azure_location
  name     = module.az_naming.naming_map[each.key].resource_group.name
  tags     = module.tagging.resource_tags

  lock = var.azure_resource_group_management_lock_level != "" ? {
    kind = var.azure_resource_group_management_lock_level
    name = "resource-group-level"
  } : null
}

module "network" {
  source = "./modules/az_network"

  vnet_name                        = module.az_naming.naming_map["networking"].virtual_network.name
  vnet_address_space               = var.vnet_address_space
  vnet_subnets                     = var.vnet_subnets
  vnet_nsg_rules                   = var.vnet_nsg_rules
  resource_group_name              = module.resource_groups["networking"].name
  resource_group_location          = var.azure_location
  regional_virtual_hub_resource_id = local.regional_virtual_hub_resource_id
  resource_tags                    = module.tagging.resource_tags
  vnet_routes                      = var.vnet_routes
  dns_servers                      = local.dns_servers
}

# Update VNet DNS settings to use domain controllers after they are created
# Update DNS servers on existing virtual network using Terraform resource
# DNS order: current region first, then remote region
resource "azurerm_virtual_network_dns_servers" "vnet_dns" {
  virtual_network_id = module.network.vnet_id
  dns_servers        = local.dns_servers

  depends_on = [module.network]
}

# Azure Container Registry (ACR)
module "acr" {
  source = "./modules/az_acr"

  create_acr_registry              = var.create_acr_registry
  acr_name                         = module.az_naming.naming_map["azcr"].container_registry.name
  resource_group_name              = module.resource_groups["azcr"].name
  resource_group_location          = var.azure_location
  acr_sku                          = var.acr_sku
  public_network_access_enabled    = var.acr_public_network_access_enabled
  retention_policy_enabled         = var.acr_retention_policy_enabled
  retention_policy_in_days         = var.acr_retention_policy_in_days
  default_retention_policy_in_days = var.acr_default_retention_policy_in_days
  geo_redundant_regions            = var.acr_geo_redundant_regions
  network_rule_set                 = var.acr_network_rule_set
  resource_tags                    = module.tagging.resource_tags

  # Primary Private Endpoint
  private_endpoint_name         = module.az_naming.naming_map["azcr"].private_endpoint.name
  private_dns_zone_resource_ids = [data.azurerm_private_dns_zone.hub["acr"].id]
  private_endpoint_subnet_id    = module.network.subnets["subn-privateendpoint-1"].resource_id

  # Secondary Private Endpoint (optional)
  create_acr_secondary_pe                 = var.create_acr_secondary_pe
  private_endpoint_secondary_name         = var.create_acr_secondary_pe ? local.extend_name_map["azcr"].private_endpoint_secondary.name : null
  secondary_pe_location                   = var.create_acr_secondary_pe ? local.remote_region : null
  secondary_private_dns_zone_resource_ids = var.create_acr_secondary_pe ? [data.azurerm_resources.paired_region_pdns_zones["acr"].resources[0].id] : []
  secondary_private_endpoint_subnet_id    = var.create_acr_secondary_pe ? data.azurerm_subnet.paired_region_pe_subnet[0].id : null

  depends_on = [module.resource_groups, module.network]
}

# =============================================================================
# Azure Front Door Profile (shared across all applications)
# The profile is created here; individual app deployments add their own
# endpoints, origins, routes, WAF policies via app-orchestration templates.
# =============================================================================
module "frontdoor" {
  source = "./modules/az_frontdoor"

  create_frontdoor    = var.create_frontdoor
  frontdoor_name      = module.az_naming.naming_map["afd"].frontdoor.name
  resource_group_name = module.resource_groups["afd"].name
  frontdoor_sku_name  = var.frontdoor_sku_name

  # Profile-only deployment - no endpoints/origins/routes
  # Applications add their own FD resources via app-orchestration
  frontdoor_endpoints     = []
  frontdoor_origin_groups = []
  frontdoor_origins       = []
  frontdoor_routes        = []
  frontdoor_rule_sets     = []

  # No WAF or security policies at profile level
  frontdoor_firewall_policies = []
  frontdoor_security_policies = []

  # No custom domains at profile level
  frontdoor_custom_domains = []

  # Other Settings
  frontdoor_response_timeout_seconds = var.frontdoor_response_timeout_seconds
  logs_destinations_ids              = var.frontdoor_logs_destinations_ids
  resource_tags                      = module.tagging.resource_tags

  depends_on = [module.resource_groups]
}

module "aks" {
  source = "./modules/az_aks"

  # Resource Group and Location
  resource_group_name = module.resource_groups["aks"].name
  azure_location      = var.azure_location
  node_resource_group = "MC-${module.resource_groups["aks"].name}"

  # Cluster Identification
  cluster_name                      = module.az_naming.naming_map["aks"].kubernetes_cluster.name
  agents_pool_name                  = lower("${substr(module.az_naming.naming_map["aks"].kubernetes_cluster.name, 0, 3)}sys")
  temporary_name_for_rotation       = "${lower(substr(module.az_naming.naming_map["aks"].kubernetes_cluster.name, 0, 3))}tmp"
  user_pool_name                    = lower("${substr(module.az_naming.naming_map["aks"].kubernetes_cluster.name, 0, 3)}usr")
  usr_np_min_count                  = var.usr_np_min_count
  usr_np_max_count                  = var.usr_np_max_count
  sys_np_min_count                  = var.sys_np_min_count
  sys_np_max_count                  = var.sys_np_max_count
  usr_np_node_count                 = var.usr_np_node_count
  sys_np_node_count                 = var.sys_np_node_count
  usr_np_node_vm_size               = var.usr_np_node_vm_size
  sys_np_node_vm_size               = var.sys_np_node_vm_size
  azure_policy_enabled              = var.aks_azure_policy_enabled
  role_based_access_control_enabled = var.aks_role_based_access_control_enabled
  rbac_aad_azure_rbac_enabled       = var.aks_azure_rbac_enabled

  # Enables workload identity for AKS cluster
  workload_identity_enabled = var.workload_identity_enabled

  # Availability Zones (typically ["1", "2", "3"] for most regions)
  agents_availability_zones = var.availability_zones
  user_pool_zones           = var.availability_zones

  # Networking
  pod_subnet_id       = module.network.subnets["subn-system-pod-1"].resource_id
  system_subnet_id    = module.network.subnets["subn-system-node-1"].resource_id
  user_subnet_id      = module.network.subnets["subn-user-node-1"].resource_id
  private_dns_zone_id = data.azurerm_private_dns_zone.hub["aks"].id

  service_cidr                        = var.service_cidr
  dns_service_ip                      = var.dns_service_ip
  network_policy                      = var.network_policy
  private_cluster_public_fqdn_enabled = var.aks_private_cluster_public_fqdn_enabled
  api_server_authorized_ip_ranges     = var.aks_api_server_authorized_ip_ranges

  # Azure AD / RBAC
  rbac_aad_tenant_id       = data.azurerm_client_config.this.tenant_id
  current_client_object_id = data.azurerm_client_config.this.object_id

  # ACR Integration
  attached_acr_id_map = var.create_acr_registry ? {
    acr = module.acr.acr_id
  } : {}

  # log Analytics Workspace
  log_analytics_workspace_id   = module.log_analytics.log_analytics_workspace_resource_id
  log_analytics_workspace_name = module.log_analytics.log_analytics_workspace_name

  # Tags
  resource_tags = module.tagging.resource_tags

  # AKS user identity

  create_aks_user_identity = var.create_aks_user_identity
  aks_user_identity_name   = module.az_naming.naming_map["identity"].user_assigned_identity.name

  # Identity and Networking
  aks_api_zone                 = data.azurerm_private_dns_zone.aks_api_zone.id
  private_dns_zone_contributor = data.azurerm_role_definition.private_dns_zone_contributor.role_definition_id

  # App Routing Add-on Configuration
  web_app_routing_enabled  = true
  default_nginx_controller = var.enable_private_link_ingress ? "None" : "AnnotationControlled"

  # System node pool taint - only critical addons (CoreDNS, kube-proxy, etc.) can schedule here
  only_critical_addons_enabled = var.only_critical_addons_enabled

  # AGIC (Application Gateway Ingress Controller) Add-on (brown-field)
  brown_field_application_gateway_for_ingress = var.enable_agic ? {
    id        = azurerm_application_gateway.agic[0].id
    subnet_id = module.network.subnets[var.agic_subnet_name].resource_id
  } : null

  depends_on = [module.resource_groups, module.network, module.acr, module.log_analytics, azurerm_application_gateway.agic]
}

# =============================================================================
# AKS Diagnostic Settings — Control-Plane Logs
# Container Insights (OMS agent) captures pod/container logs.
# This captures AKS control-plane logs that are NOT covered by Container Insights.
# =============================================================================
resource "azurerm_monitor_diagnostic_setting" "aks" {
  name                       = "diag-${module.aks.aks_cluster_name}"
  target_resource_id         = module.aks.aks_cluster_id
  log_analytics_workspace_id = module.log_analytics.log_analytics_workspace_resource_id

  # Control-plane / system logs
  enabled_log { category = "kube-apiserver" }
  enabled_log { category = "kube-audit-admin" }
  enabled_log { category = "kube-controller-manager" }
  enabled_log { category = "kube-scheduler" }
  enabled_log { category = "guard" }
  enabled_log { category = "cloud-controller-manager" }
  enabled_log { category = "cluster-autoscaler" }

  # Cluster metrics
  metric {
    category = "AllMetrics"
  }
}

# =============================================================================
# Cluster-Wide Network Policies
# NGINX namespace lockdown only. Per-namespace default-deny and app-specific
# rules are managed by the app orchestration template.
# =============================================================================
module "network_policies" {
  source = "./modules/network_policies"

  # Must wait for app-routing-system namespace to exist.
  # On a fresh cluster the AKS addon creates it asynchronously;
  # wait_2_minutes (unconditional, 120s) is the baseline guarantee.
  # wait_for_pls adds an extra 120s after the NginxIngressController CRD
  # when private-link ingress is enabled.
  depends_on = [module.aks, time_sleep.wait_2_minutes, time_sleep.wait_for_pls]
}

# =============================================================================
# Application Gateway for AGIC (brown-field)
# Created by Terraform so we control zones, SKU, and lifecycle.
# AGIC addon manages the backend pools, listeners, and routing rules.
# =============================================================================
resource "azurerm_public_ip" "agic" {
  count = var.enable_agic && !var.enable_agw_private_only ? 1 : 0

  name                = "${module.az_naming.naming_map["aks"].application_gateway.name}-pip"
  resource_group_name = module.resource_groups["aks"].name
  location            = var.azure_location
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = var.agic_zones

  tags = module.tagging.resource_tags
}

resource "azurerm_application_gateway" "agic" {
  count = var.enable_agic ? 1 : 0

  name                = module.az_naming.naming_map["aks"].application_gateway.name
  resource_group_name = module.resource_groups["aks"].name
  location            = var.azure_location
  zones               = var.agic_zones
  http2_enabled       = true

  tags = module.tagging.resource_tags

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "appGatewayIpConfig"
    subnet_id = module.network.subnets[var.agic_subnet_name].resource_id
  }

  # Public frontend - only when NOT in private-only mode
  dynamic "frontend_ip_configuration" {
    for_each = var.enable_agw_private_only ? [] : [1]
    content {
      name                 = "appGwPublicFrontendIpIPv4"
      public_ip_address_id = azurerm_public_ip.agic[0].id
    }
  }

  # Private frontend IP - always present in private-only mode, or when explicitly enabled
  dynamic "frontend_ip_configuration" {
    for_each = var.enable_agw_private_only || var.agic_enable_private_frontend ? [1] : []
    content {
      name                          = "appGwPrivateFrontendIp"
      subnet_id                     = module.network.subnets[var.agic_subnet_name].resource_id
      private_ip_address_allocation = "Static"
      private_ip_address            = local.agic_private_ip_address_effective
    }
  }

  frontend_port {
    name = "port_80"
    port = 80
  }

  # Placeholder backend pool - AGIC manages the real pools
  backend_address_pool {
    name = "defaultaddresspool"
  }

  # Placeholder HTTP settings - AGIC manages the real settings
  backend_http_settings {
    name                  = "defaulthttpsetting"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 30
  }

  # Placeholder listener - AGIC manages the real listeners
  http_listener {
    name                           = "defaultlistener"
    frontend_ip_configuration_name = var.enable_agw_private_only ? "appGwPrivateFrontendIp" : "appGwPublicFrontendIpIPv4"
    frontend_port_name             = "port_80"
    protocol                       = "Http"
  }

  # Placeholder routing rule - AGIC manages the real rules
  request_routing_rule {
    name                       = "defaultrule"
    priority                   = 19500
    rule_type                  = "Basic"
    http_listener_name         = "defaultlistener"
    backend_address_pool_name  = "defaultaddresspool"
    backend_http_settings_name = "defaulthttpsetting"
  }

  # AGIC manages the AppGw config - ignore changes to AGIC-managed blocks.
  # All dynamic blocks (listeners, rules, pools, etc.) are ignored so that
  # Terraform does not conflict with AGIC's reconciliation loop.
  lifecycle {
    precondition {
      condition     = !(var.enable_agw_private_only || var.agic_enable_private_frontend) || local.agic_private_ip_address_effective != null
      error_message = "Unable to determine AGIC private frontend IP. Set agic_private_ip_address explicitly or ensure agic_subnet_name points to a subnet with a valid CIDR."
    }

    ignore_changes = [
      backend_address_pool,
      backend_http_settings,
      frontend_port,
      http_listener,
      request_routing_rule,
      probe,
      redirect_configuration,
      url_path_map,
      ssl_certificate,
      tags["managed-by-k8s-ingress"],
    ]
  }

  depends_on = [module.network, time_sleep.wait_for_agw_network_isolation]
}

# =============================================================================
# AGIC Managed Identity - Role Assignments (REMOVED)
# The AGIC addon auto-creates these role assignments (Reader on RG, Contributor
# on AppGw, Network Contributor on VNet) during AKS provisioning with a
# brown-field Application Gateway. Terraform-managed duplicates cause 409
# RoleAssignmentExists errors on first apply. The addon also re-creates them
# if the AGIC identity is recycled, so explicit Terraform management is not
# needed.
# =============================================================================

module "log_analytics" {
  source = "./modules/az_log_analytics"

  log_analytics_workspace_name             = module.az_naming.naming_map["monitor"].log_analytics_workspace.name
  resource_group_name                      = module.resource_groups["monitor"].name
  resource_group_location                  = var.azure_location
  log_analytics_sku                        = var.log_analytics_sku
  log_analytics_retention_in_days          = var.log_analytics_retention_in_days
  log_analytics_daily_quota_gb             = var.log_analytics_daily_quota_gb
  log_analytics_internet_ingestion_enabled = var.log_analytics_internet_ingestion_enabled
  resource_tags                            = module.tagging.resource_tags

  depends_on = [module.resource_groups]
}

# =============================================================================
# Link workload LAW to the shared management AMPLS
# =============================================================================
resource "azurerm_monitor_private_link_scoped_service" "management_ampls_log_analytics" {
  provider = azurerm.management

  name                = "pls-${module.log_analytics.log_analytics_workspace_name}"
  resource_group_name = local.management_ampls_resource_group_name
  scope_name          = local.management_ampls_name
  linked_resource_id  = module.log_analytics.log_analytics_workspace_resource_id

  lifecycle {
    precondition {
      condition = (
        local.management_subscription_id != null &&
        local.management_ampls_name != null &&
        local.management_ampls_resource_group_name != null
      )
      error_message = "Management AMPLS outputs are unavailable for region ${var.azure_location}. Apply fb-management first so AMPLS outputs exist in remote state."
    }
  }

  depends_on = [module.log_analytics]
}

# =============================================================================
# AGIC Managed Identity Role Assignments (brown-field)
# The upstream AKS module's built-in role assignments are disabled via
# create_role_assignments_for_application_gateway = false to prevent 409
# RoleAssignmentExists errors on re-apply (non-deterministic GUIDs).
# We create them here with explicit names for idempotency.
#
# AGIC needs:
#   - Contributor on the Application Gateway (to manage listeners, rules, etc.)
#   - Reader on the Resource Group (to discover attached resources)
#   - Network Contributor on the VNet (to join subnets)
# =============================================================================
resource "azurerm_role_assignment" "agic_appgw_contributor" {
  count = var.enable_agic ? 1 : 0

  principal_id         = module.aks.ingress_application_gateway.ingress_application_gateway_identity[0].object_id
  scope                = azurerm_application_gateway.agic[0].id
  role_definition_name = "Contributor"
}

resource "azurerm_role_assignment" "agic_rg_reader" {
  count = var.enable_agic ? 1 : 0

  principal_id         = module.aks.ingress_application_gateway.ingress_application_gateway_identity[0].object_id
  scope                = module.resource_groups["aks"].resource_id
  role_definition_name = "Reader"
}

resource "azurerm_role_assignment" "agic_vnet_network_contributor" {
  count = var.enable_agic ? 1 : 0

  principal_id         = module.aks.ingress_application_gateway.ingress_application_gateway_identity[0].object_id
  scope                = module.network.vnet_id
  role_definition_name = "Network Contributor"
}

resource "time_sleep" "wait_2_minutes" {
  depends_on      = [module.aks]
  create_duration = "120s"
}

# =============================================================================
# Wait for RBAC to propagate before creating K8s resources
# The AKS RBAC Cluster Admin role is already assigned in the az_aks module via
# azurerm_role_assignment.aks_identity_cluster_admin_role
# =============================================================================
resource "time_sleep" "wait_for_rbac" {
  depends_on      = [module.aks]
  create_duration = "60s"
}

# =============================================================================
# App Routing: Default NGINX ingress controller is now disabled natively
# via default_nginx_controller = "None" in the AKS module's web_app_routing
# block (supported since Azure/aks/azurerm v11.3.0 + azurerm provider ~> 4.x).
# The previous azapi_update_resource workaround has been removed.
# =============================================================================

# =============================================================================
# App Routing: Internal NGINX Ingress Controller with Private Link Service
# Replaces the Helm-based NGINX ingress with Azure-managed App Routing add-on
# Creates an internal load balancer with PLS for Front Door connectivity
#
# Uses kubectl_manifest (gavinbunney/kubectl) instead of kubernetes_manifest
# because kubernetes_manifest requires CRD schema at plan time, which fails
# on first apply when AKS doesn't exist yet. kubectl_manifest works like
# 'kubectl apply' and doesn't need schema discovery at plan time.
# =============================================================================
resource "kubectl_manifest" "nginx_internal_pls" {
  count = var.enable_private_link_ingress ? 1 : 0

  yaml_body = yamlencode({
    apiVersion = "approuting.kubernetes.azure.com/v1alpha1"
    kind       = "NginxIngressController"
    metadata = {
      name = "nginx-internal-pls"
    }
    spec = {
      ingressClassName     = "nginx-internal-pls"
      controllerNamePrefix = "nginx-internal-pls"
      loadBalancerAnnotations = {
        "service.beta.kubernetes.io/azure-load-balancer-internal"        = "true"
        "service.beta.kubernetes.io/azure-load-balancer-internal-subnet" = var.ingress_subnet_name
        "service.beta.kubernetes.io/azure-pls-create"                    = "true"
        "service.beta.kubernetes.io/azure-pls-name"                      = "pls-${module.az_naming.naming_map["aks"].kubernetes_cluster.name}"
        "service.beta.kubernetes.io/azure-pls-ip-configuration-subnet"   = var.ingress_private_endpoint
        "service.beta.kubernetes.io/azure-pls-resource-group"            = module.resource_groups["aks"].name
        "service.beta.kubernetes.io/azure-pls-auto-approval"             = "*"
      }
    }
  })

  depends_on = [module.aks, time_sleep.wait_for_rbac]
}

# Wait for the ingress controller to be ready and PLS to be created
resource "time_sleep" "wait_for_pls" {
  count = var.enable_private_link_ingress ? 1 : 0

  depends_on      = [kubectl_manifest.nginx_internal_pls]
  create_duration = "120s"
}

# =============================================================================
# PLS Cleanup on Destroy
# The NginxIngressController CRD triggers AKS to create a Private Link Service
# (PLS) as a side-effect. This PLS is NOT managed by Terraform - it's created
# by AKS in the AKS resource group and references the kubernetes-internal LB
# in the MC resource group.
#
# On destroy, AKS cannot delete the MC RG because the PLS still holds a
# reference to the internal LB (CannotDeleteLoadBalancerWithPrivateLinkService).
# This terraform_data resource explicitly deletes the PLS before AKS is
# destroyed, using the correct dependency ordering:
#
# Destroy order: pls_cleanup â†’ time_sleep â†’ kubectl_manifest (CRD) â†’ module.aks
# =============================================================================
resource "terraform_data" "pls_cleanup" {
  count = var.enable_private_link_ingress ? 1 : 0

  # Store values needed by the destroy provisioner - accessible via self.output
  input = {
    pls_name            = "pls-${module.az_naming.naming_map["aks"].kubernetes_cluster.name}"
    resource_group_name = module.resource_groups["aks"].name
    subscription_id     = data.azurerm_client_config.this.subscription_id
  }

  provisioner "local-exec" {
    when    = destroy
    command = <<-EOT
      echo "=== PLS Cleanup: Deleting Private Link Service before AKS destroy ==="
      echo "PLS Name:       ${self.output.pls_name}"
      echo "Resource Group: ${self.output.resource_group_name}"
      echo "Subscription:   ${self.output.subscription_id}"

      az network private-link-service delete \
        --subscription "${self.output.subscription_id}" \
        --resource-group "${self.output.resource_group_name}" \
        --name "${self.output.pls_name}" \
        --yes 2>&1 || echo "PLS not found or already deleted - continuing"

      echo "Waiting 60s for Azure to release internal LB references..."
      sleep 60
      echo "=== PLS Cleanup complete ==="
    EOT
  }

  # Depends on the CRD + wait - so on DESTROY this runs FIRST (reverse order)
  depends_on = [kubectl_manifest.nginx_internal_pls, time_sleep.wait_for_pls]
}

# =============================================================================
# Demo Application Module
# Deploys K8s namespace, deployment, service, ingress, and network policy
# for testing Front Door -> PLS -> Ingress connectivity
# =============================================================================
module "demo_app" {
  source = "./modules/demo_app"

  deploy         = var.deploy_demo_app
  deploy_ingress = var.deploy_demo_app && var.enable_private_link_ingress
  hostname       = var.demo_app_hostname
  environment    = terraform.workspace

  depends_on = [module.aks, time_sleep.wait_for_rbac, kubectl_manifest.nginx_internal_pls]
}

# =============================================================================
# Removed Block - Helm NGINX Ingress Controller
# The ingress module was replaced by App Routing add-on. Using 'removed' block
# to cleanly destroy the Helm release from state without causing provider cycles.
# =============================================================================
removed {
  from = module.ingress

  lifecycle {
    destroy = true
  }
}

#------------------------------------------------------------------------------
# PostgreSQL Flexible Server (Entra ID Only Authentication)
#------------------------------------------------------------------------------
module "postgresql" {
  source = "./modules/az_postgresql"
  count  = var.create_postgresql ? 1 : 0

  # Naming
  postgresql_server_name = module.az_naming.naming_map["postgresql"].postgresql_flexible_server.name
  resource_group_name    = module.resource_groups["postgresql"].name
  location               = var.azure_location

  # Authentication - Entra ID Only
  tenant_id = data.azurerm_client_config.this.tenant_id
  ad_administrators = {
    "postgresql_admin" = {
      tenant_id      = data.azurerm_client_config.this.tenant_id
      object_id      = local.postgresql_admin_object_id
      principal_name = local.postgresql_admin_principal_name
      principal_type = local.postgresql_admin_principal_type
    }
  }

  # Networking - VNet Integration (delegated subnet)
  delegated_subnet_id = module.network.subnets["subn-postgresql"].resource_id
  private_dns_zone_id = data.azurerm_private_dns_zone.hub["postgresql"].id

  # Compute
  sku_name           = var.postgresql_sku_name
  storage_mb         = var.postgresql_storage_mb
  postgresql_version = var.postgresql_version

  # High Availability
  high_availability = var.postgresql_high_availability
  availability_zone = var.postgresql_availability_zone

  # Backup
  backup_retention_days        = var.postgresql_backup_retention_days
  geo_redundant_backup_enabled = var.postgresql_geo_redundant_backup_enabled

  # Maintenance - Sunday 2 AM
  maintenance_window = {
    day_of_week  = "0"
    start_hour   = 2
    start_minute = 0
  }

  # Tags
  tags = module.tagging.resource_tags
}

#------------------------------------------------------------------------------
# KEY VAULT
#------------------------------------------------------------------------------

module "keyvault" {
  source = "../../shared/modules/az_keyvault"
  count  = var.create_keyvault ? 1 : 0

  keyvault_name       = module.az_naming.naming_map["keyvault"].key_vault.name
  location            = var.azure_location
  resource_group_name = module.resource_groups["keyvault"].name
  tenant_id           = data.azurerm_client_config.this.tenant_id

  # Security Settings
  sku_name                        = var.keyvault_sku
  public_network_access_enabled   = false
  purge_protection_enabled        = var.keyvault_purge_protection_enabled
  soft_delete_retention_days      = var.keyvault_soft_delete_retention_days
  enabled_for_deployment          = var.keyvault_enabled_for_deployment
  enabled_for_disk_encryption     = var.keyvault_enabled_for_disk_encryption
  enabled_for_template_deployment = var.keyvault_enabled_for_template_deployment

  # Private Endpoint
  private_endpoints = {
    pe = {
      subnet_resource_id            = module.network.subnets["subn-privateendpoint-1"].resource_id
      private_dns_zone_resource_ids = [data.azurerm_private_dns_zone.hub["keyvault"].id]
    }
  }

  # Tags
  tags = module.tagging.resource_tags
}
