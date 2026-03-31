module "storage_account" {


  source  = "Azure/avm-res-storage-storageaccount/azurerm"
  version = "0.6.4"

  location            = var.location
  name                = var.storageaccount_name
  resource_group_name = var.resource_group_name

  account_replication_type        = var.storageaccount_account_replication_type
  default_to_oauth_authentication = var.storageaccount_default_to_oauth_authentication
  enable_telemetry                = var.enable_module_telemetry
  private_endpoints               = var.storageaccount_private_endpoints

  private_endpoints_manage_dns_zone_group = var.storage_account_private_endpoints_manage_dns_zone_group

  storage_management_policy_rule = {
    delete_old_blobs = {
      enabled = true
      name    = "delete_old_blobs"
      actions = {
        base_blob = {
          delete_after_days_since_modification_greater_than = 60
        }
        append_blob = {
          delete_after_days_since_modification_greater_than = 60
        }
      }
      filters = {
        blob_types = ["blockBlob", "appendBlob"]
      }
    }
  }

  tags = var.resource_tags
}
