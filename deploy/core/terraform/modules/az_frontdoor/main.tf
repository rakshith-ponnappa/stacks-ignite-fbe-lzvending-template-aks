module "cdn_frontdoor" {
  count   = var.create_frontdoor ? 1 : 0
  source  = "claranet/cdn-frontdoor/azurerm"
  version = "8.1.0"

  client_name              = null
  environment              = null
  stack                    = null
  name_suffix              = local.frontdoor_name_suffix
  custom_name              = var.frontdoor_name
  resource_group_name      = var.resource_group_name
  sku_name                 = var.frontdoor_sku_name
  logs_destinations_ids    = var.logs_destinations_ids
  endpoints                = var.frontdoor_endpoints
  origin_groups            = var.frontdoor_origin_groups
  origins                  = var.frontdoor_origins
  routes                   = var.frontdoor_routes
  rule_sets                = var.frontdoor_rule_sets
  firewall_policies        = var.frontdoor_firewall_policies
  security_policies        = var.frontdoor_security_policies
  custom_domains           = var.frontdoor_custom_domains
  response_timeout_seconds = local.response_timeout
  extra_tags               = var.resource_tags
}
