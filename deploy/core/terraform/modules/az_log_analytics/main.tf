resource "azurerm_log_analytics_workspace" "this" {
  name                       = var.log_analytics_workspace_name
  resource_group_name        = var.resource_group_name
  location                   = var.resource_group_location
  sku                        = var.log_analytics_sku
  retention_in_days          = var.log_analytics_retention_in_days
  daily_quota_gb             = var.log_analytics_daily_quota_gb
  internet_ingestion_enabled = var.log_analytics_internet_ingestion_enabled

  tags = var.resource_tags
}
