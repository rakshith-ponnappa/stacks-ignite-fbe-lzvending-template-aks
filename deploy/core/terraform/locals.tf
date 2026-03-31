locals {
  # Dynamic regional virtual hub selection based on current location
  regional_virtual_hub_resource_id = (
    can(module.remote_state.connectivity_remote_states[var.azure_location].virtual_hub_resource_id) ?
    module.remote_state.connectivity_remote_states[var.azure_location].virtual_hub_resource_id :
    null
  )

  # Get hub subscription ID from connectivity remote state
  hub_subscription_id = (
    can(module.remote_state.connectivity_remote_states[var.azure_location].subscription_id) ?
    module.remote_state.connectivity_remote_states[var.azure_location].subscription_id :
    null
  )

  # Management subscription and AMPLS details (for LAW -> AMPLS linking)
  management_subscription_id = (
    can(module.remote_state.management_remote_states[var.azure_location].subscription_id) ?
    module.remote_state.management_remote_states[var.azure_location].subscription_id :
    null
  )

  management_ampls_id = (
    can(module.remote_state.management_remote_states[var.azure_location].azure_monitor_private_link_scope_id) ?
    module.remote_state.management_remote_states[var.azure_location].azure_monitor_private_link_scope_id :
    null
  )

  management_ampls_name = (
    can(module.remote_state.management_remote_states[var.azure_location].azure_monitor_private_link_scope_name) ?
    module.remote_state.management_remote_states[var.azure_location].azure_monitor_private_link_scope_name :
    null
  )

  management_ampls_resource_group_name = local.management_ampls_id != null ? try(split("/", local.management_ampls_id)[4], null) : null

  # Get hub DNS zone resource group from connectivity remote state
  hub_dns_zone_resource_group = (
    can(module.remote_state.connectivity_remote_states[var.azure_location].private_dns_zones_resource_group_name) ?
    module.remote_state.connectivity_remote_states[var.azure_location].private_dns_zones_resource_group_name :
    null
  )

  # Determine the remote region based on current location
  remote_region = var.azure_location == "eastus2" ? "centralus" : "eastus2"

  # Get region name from azure_region module
  # region_name = module.azure_region.location_short

  # Private Link DNS Zones with region name substitution
  private_link_dns_zones = {
    for key, value in var.private_link_dns_zones : key => {
      zone_name = replace(value.zone_name, "{regionName}", var.azure_location)
    }
  }

  # Get DNS servers from current region first, then remote region
  current_region_dns = (
    can(module.remote_state.identity_remote_states[var.azure_location].domain_controller_private_ips) ?
    module.remote_state.identity_remote_states[var.azure_location].domain_controller_private_ips :
    []
  )

  remote_region_dns = (
    can(module.remote_state.identity_remote_states[local.remote_region].domain_controller_private_ips) ?
    module.remote_state.identity_remote_states[local.remote_region].domain_controller_private_ips :
    []
  )

  # Combine DNS servers: current region first, then remote region
  combined_dns_servers = concat(
    local.current_region_dns, # Current region existing DNS servers
    local.remote_region_dns   # Remote region DNS servers
  )

  # Remove duplicates and filter out empty values
  dns_servers = distinct([
    for ip in local.combined_dns_servers : ip
    if ip != null && ip != ""
  ])

  # Extended Naming Map for Secondary Private Endpoint
  extend_name_map = {
    for module_k, module_v in module.az_naming.naming_map : module_k => {
      "private_endpoint_secondary" = {
        name = "${module.az_naming.naming_map[module_k].private_endpoint.name}-sec"
      }
    }
  }

  # AGIC private frontend IP defaults to host .10 of the AGIC subnet CIDR
  # unless explicitly overridden via var.agic_private_ip_address.
  agic_private_ip_address_effective = coalesce(
    var.agic_private_ip_address,
    try(cidrhost(var.vnet_subnets[var.agic_subnet_name].address_prefixes[0], 10), null)
  )

  # PostgreSQL admin resolution.
  # Prefer the configured Entra group. If not found, fall back to the
  # configured fallback Entra user.
  postgresql_admin_group_lookup_required = var.create_postgresql && var.postgresql_admin_group_name != null && var.postgresql_admin_principal_type == "Group" && var.postgresql_admin_group_object_id == null
  postgresql_admin_group_object_id       = var.postgresql_admin_group_object_id != null ? var.postgresql_admin_group_object_id : try(data.azuread_groups.postgresql_admin[0].object_ids[0], null)
  use_postgresql_admin_group             = var.create_postgresql && var.postgresql_admin_group_name != null && local.postgresql_admin_group_object_id != null
  postgresql_admin_object_id             = var.create_postgresql ? (local.use_postgresql_admin_group ? local.postgresql_admin_group_object_id : data.azuread_user.postgresql_admin_fallback[0].object_id) : null
  postgresql_admin_principal_name        = var.create_postgresql ? (local.use_postgresql_admin_group ? var.postgresql_admin_group_name : var.postgresql_fallback_admin_user_principal_name) : null
  postgresql_admin_principal_type        = var.create_postgresql ? (local.use_postgresql_admin_group ? "Group" : "User") : null

  # =============================================================================
  # Private Link Service Configuration
  # PLS is auto-created by AKS when NginxIngressController has PLS annotations
  # =============================================================================
  pls_name = "pls-${module.az_naming.naming_map["aks"].kubernetes_cluster.name}"
}
