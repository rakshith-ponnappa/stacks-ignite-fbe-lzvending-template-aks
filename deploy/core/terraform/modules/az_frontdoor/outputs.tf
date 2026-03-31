output "frontdoor_id" {
  description = "The ID of the Azure Front Door profile."
  value       = try(module.cdn_frontdoor[0].id, null)
  sensitive   = false
}

output "frontdoor_name" {
  description = "The name of the Azure Front Door profile."
  value       = try(module.cdn_frontdoor[0].name, null)
  sensitive   = false
}

output "frontdoor_resource_guid" {
  description = "The resource GUID of the Azure Front Door profile."
  value       = try(module.cdn_frontdoor[0].resource.resource_guid, null)
  sensitive   = false
}

output "frontdoor_resource" {
  description = "The full Azure Front Door profile resource object."
  value       = try(module.cdn_frontdoor[0].resource, null)
  sensitive   = false
}

output "frontdoor_identity_principal_id" {
  description = "Azure CDN FrontDoor system identity principal ID."
  value       = try(module.cdn_frontdoor[0].identity_principal_id, null)
  sensitive   = false
}

output "frontdoor_endpoints" {
  description = "Map of Front Door endpoints with their details."
  value       = try(module.cdn_frontdoor[0].resource_endpoint, null)
  sensitive   = false
}

output "frontdoor_endpoint_host_names" {
  description = "Map of Front Door endpoint host names."
  value       = try({ for k, v in module.cdn_frontdoor[0].resource_endpoint : k => v.host_name }, null)
  sensitive   = false
}

output "frontdoor_origin_groups" {
  description = "Map of Front Door origin groups with their details."
  value       = try(module.cdn_frontdoor[0].resource_origin_group, null)
  sensitive   = false
}

output "frontdoor_origins" {
  description = "Map of Front Door origins with their details."
  value       = try(module.cdn_frontdoor[0].resource_origin, null)
  sensitive   = false
}

output "frontdoor_routes" {
  description = "Map of Front Door routes with their details."
  value       = try(module.cdn_frontdoor[0].resource_route, null)
  sensitive   = false
}

output "frontdoor_rule_sets" {
  description = "Map of Front Door rule sets with their details."
  value       = try(module.cdn_frontdoor[0].resource_rule_set, null)
  sensitive   = false
}

output "frontdoor_rules" {
  description = "Map of Front Door rules with their details."
  value       = try(module.cdn_frontdoor[0].resource_rule, null)
  sensitive   = false
}

output "frontdoor_custom_domains" {
  description = "Map of Front Door custom domains with their details."
  value       = try(module.cdn_frontdoor[0].resource_custom_domain, null)
  sensitive   = false
}

output "frontdoor_secrets" {
  description = "Map of Front Door secrets with their details."
  value       = try(module.cdn_frontdoor[0].resource_secret, null)
  sensitive   = true
}

output "frontdoor_firewall_policies" {
  description = "Map of Front Door WAF policies with their details."
  value       = try(module.cdn_frontdoor[0].resource_firewall_policy, null)
  sensitive   = false
}

output "frontdoor_security_policies" {
  description = "Map of Front Door security policies with their details."
  value       = try(module.cdn_frontdoor[0].resource_security_policy, null)
  sensitive   = false
}

output "frontdoor_diagnostics" {
  description = "Diagnostics Settings module output."
  value       = try(module.cdn_frontdoor[0].module_diagnostics, null)
  sensitive   = false
}
