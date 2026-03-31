output "storage_account_id" {
  description = "The ID of the Storage Account."
  value       = try(module.storage_account.resource_id, null)
  sensitive   = false
}

output "storage_account_name" {
  description = "The name of the Storage Account."
  value       = try(module.storage_account.name, null)
  sensitive   = false
}

output "storage_account_primary_location" {
  description = "The primary location of the Storage Account."
  value       = try(module.storage_account.resource.primary_location, null)
  sensitive   = false
}

output "storage_account_primary_blob_endpoint" {
  description = "The primary blob endpoint of the Storage Account."
  value       = try(module.storage_account.resource.primary_blob_endpoint, null)
  sensitive   = false
}

output "storage_account_primary_blob_host" {
  description = "The hostname with port of the primary blob endpoint of the Storage Account."
  value       = try(module.storage_account.resource.primary_blob_host, null)
  sensitive   = false
}

output "storage_account_primary_queue_endpoint" {
  description = "The primary queue endpoint of the Storage Account."
  value       = try(module.storage_account.resource.primary_queue_endpoint, null)
  sensitive   = false
}

output "storage_account_primary_table_endpoint" {
  description = "The primary table endpoint of the Storage Account."
  value       = try(module.storage_account.resource.primary_table_endpoint, null)
  sensitive   = false
}

output "storage_account_primary_file_endpoint" {
  description = "The primary file endpoint of the Storage Account."
  value       = try(module.storage_account.resource.primary_file_endpoint, null)
  sensitive   = false
}

output "storage_account_primary_access_key" {
  description = "The primary access key for the Storage Account."
  value       = try(module.storage_account.resource.primary_access_key, null)
  sensitive   = true
}

output "storage_account_secondary_access_key" {
  description = "The secondary access key for the Storage Account."
  value       = try(module.storage_account.resource.secondary_access_key, null)
  sensitive   = true
}

output "storage_account_primary_connection_string" {
  description = "The primary connection string for the Storage Account."
  value       = try(module.storage_account.resource.primary_connection_string, null)
  sensitive   = true
}

output "storage_account_private_endpoints" {
  description = "Map of private endpoints created for the Storage Account."
  value       = try(module.storage_account.private_endpoints, null)
  sensitive   = false
}
