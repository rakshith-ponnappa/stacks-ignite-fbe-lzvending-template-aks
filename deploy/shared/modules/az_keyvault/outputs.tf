#------------------------------------------------------------------------------
# OUTPUTS
#------------------------------------------------------------------------------

output "keyvault_id" {
  value       = module.keyvault.resource_id
  description = "The resource ID of the Key Vault."
}

output "keyvault_name" {
  value       = module.keyvault.name
  description = "The name of the Key Vault."
}

output "keyvault_uri" {
  value       = module.keyvault.uri
  description = "The URI of the Key Vault."
}
