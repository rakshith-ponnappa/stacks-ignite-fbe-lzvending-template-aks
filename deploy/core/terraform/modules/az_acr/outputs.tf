output "acr_resource_group_name" {
  description = "The resource group name for the Azure Container Registry."
  value       = try(module.acr_registry[0].resource.resource_group_name, null)
  sensitive   = false
}

output "acr_name" {
  description = "The name of the Azure Container Registry."
  value       = try(module.acr_registry[0].name, null)
  sensitive   = false
}

output "acr_id" {
  description = "The ID of the Azure Container Registry."
  value       = try(module.acr_registry[0].resource_id, null)
  sensitive   = false
}

output "acr_login_server" {
  description = "The login server URL of the Azure Container Registry."
  value       = try(module.acr_registry[0].resource.login_server, null)
  sensitive   = false
}
