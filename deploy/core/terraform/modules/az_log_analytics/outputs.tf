output "log_analytics_workspace_name" {
  description = "The name of the Log Analytics Workspace."
  value       = azurerm_log_analytics_workspace.this.name
  sensitive   = false
}

output "log_analytics_workspace_resource_id" {
  description = "The resource id of the Log Analytics Workspace."
  value       = azurerm_log_analytics_workspace.this.id
  sensitive   = false
}
