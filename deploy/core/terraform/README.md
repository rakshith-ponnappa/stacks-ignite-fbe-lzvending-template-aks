## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1, < 2 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | ~> 3.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 4.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 3.1.1 |
| <a name="requirement_null"></a> [null](#requirement\_null) | ~> 3.2.4 |
| <a name="requirement_time"></a> [time](#requirement\_time) | ~> 0.11 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | 3.7.0 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.58.0 |
| <a name="provider_azurerm.hub"></a> [azurerm.hub](#provider\_azurerm.hub) | 4.58.0 |
| <a name="provider_time"></a> [time](#provider\_time) | 0.13.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_acr"></a> [acr](#module\_acr) | ./modules/az_acr | n/a |
| <a name="module_aks"></a> [aks](#module\_aks) | ./modules/az_aks | n/a |
| <a name="module_az_naming"></a> [az\_naming](#module\_az\_naming) | git::https://github.com/FiveB-Infra/fb-naming.git | v2026.03.17.11 |
| <a name="module_azure_region"></a> [azure\_region](#module\_azure\_region) | claranet/regions/azurerm | 8.0.2 |
| <a name="module_frontdoor"></a> [frontdoor](#module\_frontdoor) | ./modules/az_frontdoor | n/a |
| <a name="module_ingress"></a> [ingress](#module\_ingress) | ./modules/ingress | n/a |
| <a name="module_keyvault"></a> [keyvault](#module\_keyvault) | ./modules/az_keyvault | n/a |
| <a name="module_log_analytics"></a> [log\_analytics](#module\_log\_analytics) | ./modules/az_log_analytics | n/a |
| <a name="module_network"></a> [network](#module\_network) | ./modules/az_network | n/a |
| <a name="module_postgresql"></a> [postgresql](#module\_postgresql) | ./modules/az_postgresql | n/a |
| <a name="module_remote_state"></a> [remote\_state](#module\_remote\_state) | ./modules/tf_remote_state | n/a |
| <a name="module_resource_groups"></a> [resource\_groups](#module\_resource\_groups) | Azure/avm-res-resources-resourcegroup/azurerm | 0.2.1 |
| <a name="module_storage_account"></a> [storage\_account](#module\_storage\_account) | ./modules/az_storage | n/a |
| <a name="module_tagging"></a> [tagging](#module\_tagging) | git::https://github.com/FiveB-Infra/fb-tagging.git | v2026.03.10.4 |

## Resources

| Name | Type |
|------|------|
| [azurerm_virtual_network_dns_servers.vnet_dns](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_dns_servers) | resource |
| [time_sleep.wait_2_minutes](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [azuread_group.postgresql_admin](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azurerm_client_config.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_private_dns_zone.aks_api_zone](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/private_dns_zone) | data source |
| [azurerm_private_dns_zone.hub](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/private_dns_zone) | data source |
| [azurerm_resources.paired_region_pdns_zones](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resources) | data source |
| [azurerm_role_definition.private_dns_zone_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/role_definition) | data source |
| [azurerm_subnet.paired_region_pe_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_Application"></a> [Application](#input\_Application) | Identifies the application related to the resource. | `string` | n/a | yes |
| <a name="input_ApplicationCode"></a> [ApplicationCode](#input\_ApplicationCode) | Links the application to the approved application list. | `string` | n/a | yes |
| <a name="input_CostCode"></a> [CostCode](#input\_CostCode) | The cost allocation code or budget code associated with the resource. | `string` | n/a | yes |
| <a name="input_CreatedBy"></a> [CreatedBy](#input\_CreatedBy) | Email address of the engineer who provisioned the resource. | `string` | n/a | yes |
| <a name="input_CreatedOn"></a> [CreatedOn](#input\_CreatedOn) | The date the ARM deployment for the resource occurred, for example â€œ2019-08-27T16:30:10.7936410+01:00â€. (The use of the UTC time zone is recommended for consistency). | `string` | n/a | yes |
| <a name="input_Criticality"></a> [Criticality](#input\_Criticality) | Denotes the importance of a service and availability requirement. E.g. Low (95%), Medium (99.5%), High (99.9%) and Critical (99.95%) | `string` | n/a | yes |
| <a name="input_Environment"></a> [Environment](#input\_Environment) | Product lifecycle stage. | `string` | n/a | yes |
| <a name="input_Monitoring"></a> [Monitoring](#input\_Monitoring) | The monitoring solution used. | `string` | n/a | yes |
| <a name="input_Owner"></a> [Owner](#input\_Owner) | The business Owner of the Resource Group/Resource. | `string` | n/a | yes |
| <a name="input_ProductDomain"></a> [ProductDomain](#input\_ProductDomain) | Identifies the product group and associated development team. | `string` | n/a | yes |
| <a name="input_Role"></a> [Role](#input\_Role) | Roles of service | `string` | n/a | yes |
| <a name="input_acr_default_retention_policy_in_days"></a> [acr\_default\_retention\_policy\_in\_days](#input\_acr\_default\_retention\_policy\_in\_days) | The default retention policy in days when retention policy is disabled | `number` | `7` | no |
| <a name="input_acr_geo_redundant_regions"></a> [acr\_geo\_redundant\_regions](#input\_acr\_geo\_redundant\_regions) | List of regions for geo-replication | `list(string)` | `[]` | no |
| <a name="input_acr_network_rule_set"></a> [acr\_network\_rule\_set](#input\_acr\_network\_rule\_set) | Network rule set configuration for the ACR | <pre>object({<br/>    default_action = optional(string, "Deny")<br/>    ip_rules = optional(list(object({<br/>      ip_range = string<br/>    })), [])<br/>  })</pre> | `null` | no |
| <a name="input_acr_public_network_access_enabled"></a> [acr\_public\_network\_access\_enabled](#input\_acr\_public\_network\_access\_enabled) | Whether public network access is enabled for the ACR | `bool` | `false` | no |
| <a name="input_acr_retention_policy_enabled"></a> [acr\_retention\_policy\_enabled](#input\_acr\_retention\_policy\_enabled) | Whether retention policy is enabled for the ACR | `bool` | `true` | no |
| <a name="input_acr_retention_policy_in_days"></a> [acr\_retention\_policy\_in\_days](#input\_acr\_retention\_policy\_in\_days) | The number of days to retain untagged manifests | `number` | `7` | no |
| <a name="input_acr_sku"></a> [acr\_sku](#input\_acr\_sku) | The SKU of the Azure Container Registry (Basic, Standard, Premium) | `string` | `"Premium"` | no |
| <a name="input_aks_aad_server_app_id"></a> [aks\_aad\_server\_app\_id](#input\_aks\_aad\_server\_app\_id) | The AKS AAD Server application ID. | `string` | `"6dae42f8-4368-4678-94ff-3960e28e3630"` | no |
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | List of availability zones for AKS node pools | `list(string)` | <pre>[<br/>  "2",<br/>  "3"<br/>]</pre> | no |
| <a name="input_azure_location"></a> [azure\_location](#input\_azure\_location) | The Azure location to target all resources. | `string` | n/a | yes |
| <a name="input_azure_resource_group_management_lock_level"></a> [azure\_resource\_group\_management\_lock\_level](#input\_azure\_resource\_group\_management\_lock\_level) | (Optional) The management lock level to apply to resource groups. | `string` | `""` | no |
| <a name="input_azure_spn_client_secret"></a> [azure\_spn\_client\_secret](#input\_azure\_spn\_client\_secret) | Client Secret for the Azure SPN | `string` | n/a | yes |
| <a name="input_component_names"></a> [component\_names](#input\_component\_names) | A list of component names which can be used in naming of resources used with different module calls. | `set(string)` | n/a | yes |
| <a name="input_create_acr_registry"></a> [create\_acr\_registry](#input\_create\_acr\_registry) | Whether to create the Azure Container Registry | `bool` | `true` | no |
| <a name="input_create_acr_secondary_pe"></a> [create\_acr\_secondary\_pe](#input\_create\_acr\_secondary\_pe) | Whether to create a secondary private endpoint for the ACR | `bool` | `false` | no |
| <a name="input_create_aks_user_identity"></a> [create\_aks\_user\_identity](#input\_create\_aks\_user\_identity) | Flag to create AKS user-assigned identity. | `bool` | `true` | no |
| <a name="input_create_frontdoor"></a> [create\_frontdoor](#input\_create\_frontdoor) | Whether to create the Azure Front Door | `bool` | `true` | no |
| <a name="input_create_keyvault"></a> [create\_keyvault](#input\_create\_keyvault) | Whether to create a Key Vault resource. | `bool` | `false` | no |
| <a name="input_create_postgresql"></a> [create\_postgresql](#input\_create\_postgresql) | Whether to create the PostgreSQL Flexible Server | `bool` | `true` | no |
| <a name="input_dns_service_ip"></a> [dns\_service\_ip](#input\_dns\_service\_ip) | The DNS service IP for the AKS cluster. | `string` | `""` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name | `string` | n/a | yes |
| <a name="input_frontdoor_custom_domains"></a> [frontdoor\_custom\_domains](#input\_frontdoor\_custom\_domains) | Azure CDN FrontDoor custom domains configurations. | <pre>list(object({<br/>    name                 = string<br/>    custom_resource_name = optional(string)<br/>    host_name            = string<br/>    dns_zone_id          = optional(string)<br/>    tls = optional(object({<br/>      certificate_type         = optional(string, "ManagedCertificate")<br/>      minimum_tls_version      = optional(string, "TLS12")<br/>      cdn_frontdoor_secret_id  = optional(string)<br/>      key_vault_certificate_id = optional(string)<br/>    }), {})<br/>  }))</pre> | `[]` | no |
| <a name="input_frontdoor_logs_destinations_ids"></a> [frontdoor\_logs\_destinations\_ids](#input\_frontdoor\_logs\_destinations\_ids) | List of destination resource IDs for sending Front Door logs | `list(string)` | `[]` | no |
| <a name="input_frontdoor_response_timeout_seconds"></a> [frontdoor\_response\_timeout\_seconds](#input\_frontdoor\_response\_timeout\_seconds) | Specifies the maximum response timeout in seconds. Possible values are between `16` and `240` seconds (inclusive). | `number` | `120` | no |
| <a name="input_frontdoor_rule_sets"></a> [frontdoor\_rule\_sets](#input\_frontdoor\_rule\_sets) | Azure CDN FrontDoor rule sets and associated rules configurations. | <pre>list(object({<br/>    name                 = string<br/>    custom_resource_name = optional(string)<br/>    rules = optional(list(object({<br/>      name                 = string<br/>      custom_resource_name = optional(string)<br/>      order                = number<br/>      behavior_on_match    = optional(string, "Continue")<br/>      actions              = any<br/>      conditions           = optional(any, null)<br/>    })), [])<br/>  }))</pre> | `[]` | no |
| <a name="input_frontdoor_sku_name"></a> [frontdoor\_sku\_name](#input\_frontdoor\_sku\_name) | Specifies the SKU for this Azure CDN FrontDoor profile. Possible values include `Standard_AzureFrontDoor` and `Premium_AzureFrontDoor`. | `string` | `"Premium_AzureFrontDoor"` | no |
| <a name="input_ingress_chart_name"></a> [ingress\_chart\_name](#input\_ingress\_chart\_name) | Ingress chart name | `string` | `"ingress-nginx"` | no |
| <a name="input_ingress_name"></a> [ingress\_name](#input\_ingress\_name) | Name of the ingress | `string` | `"ingress-nginx"` | no |
| <a name="input_ingress_namespace"></a> [ingress\_namespace](#input\_ingress\_namespace) | Namespace of the ingress | `string` | `"ingress-basic"` | no |
| <a name="input_ingress_nginx_chart_version"></a> [ingress\_nginx\_chart\_version](#input\_ingress\_nginx\_chart\_version) | The version of the ingress-nginx helm chart to install | `string` | `"4.14.1"` | no |
| <a name="input_ingress_private_endpoint"></a> [ingress\_private\_endpoint](#input\_ingress\_private\_endpoint) | Private endpoint for the Ingress | `string` | `"subn-privateendpoint-1"` | no |
| <a name="input_ingress_repository_url"></a> [ingress\_repository\_url](#input\_ingress\_repository\_url) | URL of the ingress repository | `string` | `"https://kubernetes.github.io/ingress-nginx"` | no |
| <a name="input_ingress_subnet_name"></a> [ingress\_subnet\_name](#input\_ingress\_subnet\_name) | Ingress subnet | `string` | `"subn-system-node-1"` | no |
| <a name="input_keyvault_enabled_for_deployment"></a> [keyvault\_enabled\_for\_deployment](#input\_keyvault\_enabled\_for\_deployment) | Whether Azure VMs can retrieve certificates from the Key Vault. | `bool` | `false` | no |
| <a name="input_keyvault_enabled_for_disk_encryption"></a> [keyvault\_enabled\_for\_disk\_encryption](#input\_keyvault\_enabled\_for\_disk\_encryption) | Whether Azure Disk Encryption can retrieve secrets and unwrap keys. | `bool` | `false` | no |
| <a name="input_keyvault_enabled_for_template_deployment"></a> [keyvault\_enabled\_for\_template\_deployment](#input\_keyvault\_enabled\_for\_template\_deployment) | Whether Azure Resource Manager can retrieve secrets from the Key Vault. | `bool` | `false` | no |
| <a name="input_keyvault_purge_protection_enabled"></a> [keyvault\_purge\_protection\_enabled](#input\_keyvault\_purge\_protection\_enabled) | Whether purge protection is enabled. Recommended for production. | `bool` | `true` | no |
| <a name="input_keyvault_sku"></a> [keyvault\_sku](#input\_keyvault\_sku) | The SKU of the Key Vault. Possible values are 'standard' or 'premium'. | `string` | `"standard"` | no |
| <a name="input_keyvault_soft_delete_retention_days"></a> [keyvault\_soft\_delete\_retention\_days](#input\_keyvault\_soft\_delete\_retention\_days) | The number of days to retain soft-deleted keys (7-90). | `number` | `90` | no |
| <a name="input_log_analytics_daily_quota_gb"></a> [log\_analytics\_daily\_quota\_gb](#input\_log\_analytics\_daily\_quota\_gb) | The daily quota limit, when this is reached no more data ingestion until the quota is reset at midnight. `null` = not limit | `string` | `null` | no |
| <a name="input_log_analytics_internet_ingestion_enabled"></a> [log\_analytics\_internet\_ingestion\_enabled](#input\_log\_analytics\_internet\_ingestion\_enabled) | Should the Log Analytics Workspace support ingestion over the Public Internet | `bool` | `false` | no |
| <a name="input_log_analytics_retention_in_days"></a> [log\_analytics\_retention\_in\_days](#input\_log\_analytics\_retention\_in\_days) | The data rentension in days. | `string` | `30` | no |
| <a name="input_log_analytics_sku"></a> [log\_analytics\_sku](#input\_log\_analytics\_sku) | The SKU of the Log Analytics Workspace. | `string` | `"PerGB2018"` | no |
| <a name="input_lz_short_code"></a> [lz\_short\_code](#input\_lz\_short\_code) | A short code for the LZ to use in naming of resources. | `string` | n/a | yes |
| <a name="input_paired_region_pe_subnet_name"></a> [paired\_region\_pe\_subnet\_name](#input\_paired\_region\_pe\_subnet\_name) | The subnet name for private endpoints in the paired region | `string` | `null` | no |
| <a name="input_paired_region_private_dns_zone_resource_group_name"></a> [paired\_region\_private\_dns\_zone\_resource\_group\_name](#input\_paired\_region\_private\_dns\_zone\_resource\_group\_name) | The resource group name where the paired region private DNS zones are located | `string` | `null` | no |
| <a name="input_paired_region_vnet_name"></a> [paired\_region\_vnet\_name](#input\_paired\_region\_vnet\_name) | The VNet name in the paired region | `string` | `null` | no |
| <a name="input_paired_region_vnet_resource_group_name"></a> [paired\_region\_vnet\_resource\_group\_name](#input\_paired\_region\_vnet\_resource\_group\_name) | The resource group name for the VNet in the paired region | `string` | `null` | no |
| <a name="input_postgresql_admin_group_name"></a> [postgresql\_admin\_group\_name](#input\_postgresql\_admin\_group\_name) | Display name of the Entra ID group for PostgreSQL administrators | `string` | `null` | no |
| <a name="input_postgresql_admin_group_object_id"></a> [postgresql\_admin\_group\_object\_id](#input\_postgresql\_admin\_group\_object\_id) | Optional object ID override for the Entra ID group. If null, object_id is resolved via data.azuread_group using postgresql_admin_group_name. | `string` | `null` | no |
| <a name="input_postgresql_admin_principal_type"></a> [postgresql\_admin\_principal\_type](#input\_postgresql\_admin\_principal\_type) | Principal type for PostgreSQL Entra ID admin. This template uses Group-based administration. | `string` | `"Group"` | no |
| <a name="input_postgresql_availability_zone"></a> [postgresql\_availability\_zone](#input\_postgresql\_availability\_zone) | Availability zone for primary server (1, 2, or 3). Required for production HA. | `string` | `null` | no |
| <a name="input_postgresql_backup_retention_days"></a> [postgresql\_backup\_retention\_days](#input\_postgresql\_backup\_retention\_days) | Backup retention days (7-35). Prod should use 35. | `number` | `7` | no |
| <a name="input_postgresql_geo_redundant_backup_enabled"></a> [postgresql\_geo\_redundant\_backup\_enabled](#input\_postgresql\_geo\_redundant\_backup\_enabled) | Enable geo-redundant backups. Recommended for production. | `bool` | `false` | no |
| <a name="input_postgresql_high_availability"></a> [postgresql\_high\_availability](#input\_postgresql\_high\_availability) | High availability configuration. Set to { mode = 'ZoneRedundant', standby\_availability\_zone = '2' } for production. | <pre>object({<br/>    mode                      = string<br/>    standby_availability_zone = optional(string)<br/>  })</pre> | `null` | no |
| <a name="input_postgresql_sku_name"></a> [postgresql\_sku\_name](#input\_postgresql\_sku\_name) | PostgreSQL SKU name. Dev/Test: B\_Standard\_B1ms, Prod: GP\_Standard\_D4s\_v3 | `string` | `"B_Standard_B1ms"` | no |
| <a name="input_postgresql_storage_mb"></a> [postgresql\_storage\_mb](#input\_postgresql\_storage\_mb) | PostgreSQL storage size in MB (32768 = 32GB) | `number` | `32768` | no |
| <a name="input_postgresql_version"></a> [postgresql\_version](#input\_postgresql\_version) | PostgreSQL version (17 is current stable) | `string` | `"17"` | no |
| <a name="input_private_link_dns_zones"></a> [private\_link\_dns\_zones](#input\_private\_link\_dns\_zones) | Map of private DNS zones | <pre>map(object({<br/>    zone_name = string<br/>  }))</pre> | <pre>{<br/>  "acr": {<br/>    "zone_name": "privatelink.azurecr.io"<br/>  },<br/>  "aks": {<br/>    "zone_name": "privatelink.{regionName}.azmk8s.io"<br/>  },<br/>  "blob": {<br/>    "zone_name": "privatelink.blob.core.windows.net"<br/>  },<br/>  "keyvault": {<br/>    "zone_name": "privatelink.vaultcore.azure.net"<br/>  },<br/>  "postgresql": {<br/>    "zone_name": "privatelink.postgres.database.azure.com"<br/>  }<br/>}</pre> | no |
| <a name="input_service_cidr"></a> [service\_cidr](#input\_service\_cidr) | The service CIDR for the AKS cluster. | `string` | `""` | no |
| <a name="input_storageaccount_access_tier"></a> [storageaccount\_access\_tier](#input\_storageaccount\_access\_tier) | Defines the access tier for `BlobStorage`, `FileStorage` and `StorageV2` accounts. Valid options are `Hot` and `Cool`. | `string` | `"Hot"` | no |
| <a name="input_storageaccount_account_kind"></a> [storageaccount\_account\_kind](#input\_storageaccount\_account\_kind) | Defines the Kind of account. Valid options are `BlobStorage`, `BlockBlobStorage`, `FileStorage`, `Storage` and `StorageV2`. | `string` | `"StorageV2"` | no |
| <a name="input_storageaccount_account_replication_type"></a> [storageaccount\_account\_replication\_type](#input\_storageaccount\_account\_replication\_type) | Defines the type of replication to use for this storage account. Valid options are `LRS`, `GRS`, `RAGRS`, `ZRS`, `GZRS` and `RAGZRS`. | `string` | `"ZRS"` | no |
| <a name="input_storageaccount_account_tier"></a> [storageaccount\_account\_tier](#input\_storageaccount\_account\_tier) | Defines the Tier to use for this storage account. Valid options are `Standard` and `Premium`. | `string` | `"Standard"` | no |
| <a name="input_storageaccount_allow_nested_items_to_be_public"></a> [storageaccount\_allow\_nested\_items\_to\_be\_public](#input\_storageaccount\_allow\_nested\_items\_to\_be\_public) | Allow or disallow nested items within this Account to opt into being public. | `bool` | `false` | no |
| <a name="input_storageaccount_cross_tenant_replication_enabled"></a> [storageaccount\_cross\_tenant\_replication\_enabled](#input\_storageaccount\_cross\_tenant\_replication\_enabled) | Should cross Tenant replication be enabled? | `bool` | `false` | no |
| <a name="input_storageaccount_default_to_oauth_authentication"></a> [storageaccount\_default\_to\_oauth\_authentication](#input\_storageaccount\_default\_to\_oauth\_authentication) | Default to Azure Active Directory authorization in the Azure portal when accessing the Storage Account. | `bool` | `false` | no |
| <a name="input_storageaccount_https_traffic_only_enabled"></a> [storageaccount\_https\_traffic\_only\_enabled](#input\_storageaccount\_https\_traffic\_only\_enabled) | Boolean flag which forces HTTPS if enabled. | `bool` | `true` | no |
| <a name="input_storageaccount_infrastructure_encryption_enabled"></a> [storageaccount\_infrastructure\_encryption\_enabled](#input\_storageaccount\_infrastructure\_encryption\_enabled) | Is infrastructure encryption enabled? | `bool` | `true` | no |
| <a name="input_storageaccount_management_policy_rules"></a> [storageaccount\_management\_policy\_rules](#input\_storageaccount\_management\_policy\_rules) | Storage management policy rules for lifecycle management. | <pre>map(object({<br/>    enabled = optional(bool, true)<br/>    name    = string<br/>    actions = object({<br/>      base_blob = optional(object({<br/>        delete_after_days_since_modification_greater_than          = optional(number)<br/>        tier_to_cool_after_days_since_modification_greater_than    = optional(number)<br/>        tier_to_archive_after_days_since_modification_greater_than = optional(number)<br/>      }))<br/>      snapshot = optional(object({<br/>        delete_after_days_since_creation_greater_than = optional(number)<br/>      }))<br/>      version = optional(object({<br/>        delete_after_days_since_creation = optional(number)<br/>      }))<br/>    })<br/>    filters = object({<br/>      blob_types   = set(string)<br/>      prefix_match = optional(set(string))<br/>    })<br/>  }))</pre> | `{}` | no |
| <a name="input_storageaccount_min_tls_version"></a> [storageaccount\_min\_tls\_version](#input\_storageaccount\_min\_tls\_version) | The minimum supported TLS version for the storage account. | `string` | `"TLS1_2"` | no |
| <a name="input_storageaccount_network_rules"></a> [storageaccount\_network\_rules](#input\_storageaccount\_network\_rules) | Network rules for the storage account. | <pre>object({<br/>    bypass                     = optional(set(string), ["AzureServices"])<br/>    default_action             = optional(string, "Deny")<br/>    ip_rules                   = optional(set(string), [])<br/>    virtual_network_subnet_ids = optional(set(string), [])<br/>    private_link_access = optional(list(object({<br/>      endpoint_resource_id = string<br/>      endpoint_tenant_id   = optional(string)<br/>    })))<br/>    timeouts = optional(object({<br/>      create = optional(string)<br/>      delete = optional(string)<br/>      read   = optional(string)<br/>      update = optional(string)<br/>    }))<br/>  })</pre> | `null` | no |
| <a name="input_storageaccount_nfsv3_enabled"></a> [storageaccount\_nfsv3\_enabled](#input\_storageaccount\_nfsv3\_enabled) | Is NFSv3 protocol enabled? | `bool` | `false` | no |
| <a name="input_storageaccount_public_network_access_enabled"></a> [storageaccount\_public\_network\_access\_enabled](#input\_storageaccount\_public\_network\_access\_enabled) | Whether the public network access is enabled. | `bool` | `false` | no |
| <a name="input_storageaccount_shared_access_key_enabled"></a> [storageaccount\_shared\_access\_key\_enabled](#input\_storageaccount\_shared\_access\_key\_enabled) | Indicates whether the storage account permits requests to be authorized with the account access key via Shared Key. | `bool` | `true` | no |
| <a name="input_sys_np_max_count"></a> [sys\_np\_max\_count](#input\_sys\_np\_max\_count) | The maximum number of nodes for the system node pool. | `number` | `1` | no |
| <a name="input_sys_np_min_count"></a> [sys\_np\_min\_count](#input\_sys\_np\_min\_count) | The minimum number of nodes for the system node pool. | `number` | `1` | no |
| <a name="input_sys_np_node_count"></a> [sys\_np\_node\_count](#input\_sys\_np\_node\_count) | Initial number of nodes for the system node pool. | `number` | `1` | no |
| <a name="input_sys_np_node_vm_size"></a> [sys\_np\_node\_vm\_size](#input\_sys\_np\_node\_vm\_size) | The VM size for the system node pool. | `string` | `"Standard_D2ds_v5"` | no |
| <a name="input_usr_np_max_count"></a> [usr\_np\_max\_count](#input\_usr\_np\_max\_count) | The maximum number of nodes for the user node pool. | `number` | `1` | no |
| <a name="input_usr_np_min_count"></a> [usr\_np\_min\_count](#input\_usr\_np\_min\_count) | The minimum number of nodes for the user node pool. | `number` | `1` | no |
| <a name="input_usr_np_node_count"></a> [usr\_np\_node\_count](#input\_usr\_np\_node\_count) | Initial number of nodes for the user node pool. | `number` | `1` | no |
| <a name="input_usr_np_node_vm_size"></a> [usr\_np\_node\_vm\_size](#input\_usr\_np\_node\_vm\_size) | The VM size for the user node pool. | `string` | `"Standard_D2ds_v5"` | no |
| <a name="input_vnet_address_space"></a> [vnet\_address\_space](#input\_vnet\_address\_space) | The address space applied to the virtual network. You can supply more than one address space. | `list(string)` | n/a | yes |
| <a name="input_vnet_nsg_rules"></a> [vnet\_nsg\_rules](#input\_vnet\_nsg\_rules) | A map of NSG rules to create. | <pre>map(object({<br/>    name                       = string<br/>    priority                   = number<br/>    direction                  = string<br/>    access                     = string<br/>    protocol                   = string<br/>    source_port_range          = string<br/>    destination_port_range     = string<br/>    source_address_prefix      = string<br/>    destination_address_prefix = string<br/>  }))</pre> | `{}` | no |
| <a name="input_vnet_routes"></a> [vnet\_routes](#input\_vnet\_routes) | (Optional) A map of route objects to create on the route table. | <pre>map(object({<br/>    name                   = string<br/>    address_prefix         = string<br/>    next_hop_type          = string<br/>    next_hop_in_ip_address = optional(string)<br/>  }))</pre> | `{}` | no |
| <a name="input_vnet_subnets"></a> [vnet\_subnets](#input\_vnet\_subnets) | A map of subnets to create. | <pre>map(object({<br/>    name                                          = string<br/>    address_prefixes                              = list(string)<br/>    nsg_rule_names                                = list(string)<br/>    default_outbound_access_enabled               = optional(bool, false)<br/>    route_names                                   = optional(list(string), [])<br/>    private_link_service_network_policies_enabled = optional(bool, true)<br/>    delegation = optional(list(object({<br/>      name = string<br/>      service_delegation = object({<br/>        name = string<br/>      })<br/>    })), [])<br/>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_app_name_debug"></a> [app\_name\_debug](#output\_app\_name\_debug) | n/a |
| <a name="output_keyvault_id"></a> [keyvault\_id](#output\_keyvault\_id) | Key Vault resource ID |
| <a name="output_keyvault_name"></a> [keyvault\_name](#output\_keyvault\_name) | Key Vault name |
| <a name="output_keyvault_uri"></a> [keyvault\_uri](#output\_keyvault\_uri) | Key Vault URI |
| <a name="output_postgresql_connection_info"></a> [postgresql\_connection\_info](#output\_postgresql\_connection\_info) | Connection information for applications |
| <a name="output_postgresql_server_fqdn"></a> [postgresql\_server\_fqdn](#output\_postgresql\_server\_fqdn) | Fully qualified domain name of the PostgreSQL server |
| <a name="output_postgresql_server_id"></a> [postgresql\_server\_id](#output\_postgresql\_server\_id) | PostgreSQL Flexible Server resource ID |
| <a name="output_postgresql_server_name"></a> [postgresql\_server\_name](#output\_postgresql\_server\_name) | PostgreSQL Flexible Server name |
| <a name="output_repo_name_debug"></a> [repo\_name\_debug](#output\_repo\_name\_debug) | n/a |

<!-- BEGIN_TF_DOCS -->
## Providers

| Name | Version |
|------|---------|
| azapi | ~> 2.0 |
| azuread | ~> 3.0 |
| azurerm | ~> 4.62.0 |
| azurerm.hub | ~> 4.62.0 |
| azurerm.management | ~> 4.62.0 |
| kubectl | ~> 1.19 |
| terraform | n/a |
| time | ~> 0.11 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| acr | ./modules/az_acr | n/a |
| aks | ./modules/az_aks | n/a |
| az\_naming | git::https://github.com/FiveB-Infra/fb-naming.git | v2026.03.17.11 |
| azure\_region | claranet/regions/azurerm | 8.0.2 |
| demo\_app | ./modules/demo_app | n/a |
| frontdoor | ./modules/az_frontdoor | n/a |
| keyvault | ../../shared/modules/az_keyvault | n/a |
| log\_analytics | ./modules/az_log_analytics | n/a |
| network | ./modules/az_network | n/a |
| network\_policies | ./modules/network_policies | n/a |
| postgresql | ./modules/az_postgresql | n/a |
| remote\_state | ../../shared/modules/tf_remote_state | n/a |
| resource\_groups | Azure/avm-res-resources-resourcegroup/azurerm | 0.2.1 |
| tagging | git::https://github.com/FiveB-Infra/fb-tagging.git | v2026.03.10.4 |

## Resources

| Name | Type |
|------|------|
| [azapi_resource_action.agw_network_isolation](https://registry.terraform.io/providers/Azure/azapi/latest/docs/resources/resource_action) | resource |
| [azurerm_application_gateway.agic](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_gateway) | resource |
| [azurerm_monitor_diagnostic_setting.aks](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_monitor_private_link_scoped_service.management_ampls_log_analytics](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_private_link_scoped_service) | resource |
| [azurerm_public_ip.agic](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_role_assignment.agic_appgw_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.agic_rg_reader](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.agic_vnet_network_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_virtual_network_dns_servers.vnet_dns](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_dns_servers) | resource |
| [kubectl_manifest.nginx_internal_pls](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [terraform_data.pls_cleanup](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/resources/data) | resource |
| [time_sleep.wait_2_minutes](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [time_sleep.wait_for_agw_network_isolation](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [time_sleep.wait_for_pls](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [time_sleep.wait_for_rbac](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [azuread_groups.postgresql_admin](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/groups) | data source |
| [azuread_user.postgresql_admin_fallback](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/user) | data source |
| [azurerm_client_config.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_kubernetes_cluster.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/kubernetes_cluster) | data source |
| [azurerm_private_dns_zone.aks_api_zone](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/private_dns_zone) | data source |
| [azurerm_private_dns_zone.hub](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/private_dns_zone) | data source |
| [azurerm_resources.paired_region_pdns_zones](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resources) | data source |
| [azurerm_role_definition.private_dns_zone_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/role_definition) | data source |
| [azurerm_subnet.paired_region_pe_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| Application | Identifies the application related to the resource. | `string` | n/a | yes |
| ApplicationCode | Links the application to the approved application list. | `string` | n/a | yes |
| CostCode | The cost allocation code or budget code associated with the resource. | `string` | n/a | yes |
| CreatedBy | Email address of the engineer who provisioned the resource. | `string` | n/a | yes |
| CreatedOn | The date the ARM deployment for the resource occurred, for example “2019-08-27T16:30:10.7936410+01:00”. (The use of the UTC time zone is recommended for consistency). | `string` | n/a | yes |
| Criticality | Denotes the importance of a service and availability requirement. E.g. Low (95%), Medium (99.5%), High (99.9%) and Critical (99.95%) | `string` | n/a | yes |
| Environment | Product lifecycle stage. | `string` | n/a | yes |
| Monitoring | The monitoring solution used. | `string` | n/a | yes |
| Owner | The business Owner of the Resource Group/Resource. | `string` | n/a | yes |
| ProductDomain | Identifies the product group and associated development team. | `string` | n/a | yes |
| Role | Roles of service | `string` | n/a | yes |
| acr\_default\_retention\_policy\_in\_days | The default retention policy in days when retention policy is disabled | `number` | `7` | no |
| acr\_geo\_redundant\_regions | List of regions for geo-replication | `list(string)` | `[]` | no |
| acr\_network\_rule\_set | Network rule set configuration for the ACR | <pre>object({<br/>    default_action = optional(string, "Deny")<br/>    ip_rules = optional(list(object({<br/>      ip_range = string<br/>    })), [])<br/>  })</pre> | `null` | no |
| acr\_public\_network\_access\_enabled | Whether public network access is enabled for the ACR | `bool` | `false` | no |
| acr\_retention\_policy\_enabled | Whether retention policy is enabled for the ACR | `bool` | `true` | no |
| acr\_retention\_policy\_in\_days | The number of days to retain untagged manifests | `number` | `7` | no |
| acr\_sku | The SKU of the Azure Container Registry (Basic, Standard, Premium) | `string` | `"Premium"` | no |
| agic\_enable\_private\_frontend | Enable private frontend IP on AppGw for internal-only ingress (use-private-ip annotation) | `bool` | `false` | no |
| agic\_private\_ip\_address | Optional static private IP for AppGw private frontend. If null, derives host .10 from the AGIC subnet CIDR. | `string` | `null` | no |
| agic\_subnet\_name | The subnet name for the Application Gateway used by AGIC | `string` | `"subn-appgw-1"` | no |
| agic\_zones | Availability zones for the Application Gateway and its public IP (zone-redundant) | `list(string)` | <pre>[<br/>  "1",<br/>  "2",<br/>  "3"<br/>]</pre> | no |
| aks\_aad\_server\_app\_id | The AKS AAD Server application ID. | `string` | `"6dae42f8-4368-4678-94ff-3960e28e3630"` | no |
| aks\_api\_server\_authorized\_ip\_ranges | Optional CIDR allow-list for AKS API server access. | `set(string)` | `null` | no |
| aks\_azure\_policy\_enabled | Enable the Azure Policy add-on for AKS clusters. | `bool` | `true` | no |
| aks\_azure\_rbac\_enabled | Enable Azure RBAC integration for AKS. | `bool` | `true` | no |
| aks\_private\_cluster\_public\_fqdn\_enabled | Create a public FQDN for a private AKS API server. | `bool` | `false` | no |
| aks\_role\_based\_access\_control\_enabled | Enable Kubernetes RBAC on AKS. | `bool` | `true` | no |
| availability\_zones | List of availability zones for AKS node pools | `list(string)` | <pre>[<br/>  "2",<br/>  "3"<br/>]</pre> | no |
| azure\_location | The Azure location to target all resources. | `string` | n/a | yes |
| azure\_resource\_group\_management\_lock\_level | (Optional) The management lock level to apply to resource groups. | `string` | `""` | no |
| azure\_spn\_client\_secret | Client Secret for the Azure SPN | `string` | n/a | yes |
| component\_names | A list of component names which can be used in naming of resources used with different module calls. | `set(string)` | n/a | yes |
| create\_acr\_registry | Whether to create the Azure Container Registry | `bool` | `true` | no |
| create\_acr\_secondary\_pe | Whether to create a secondary private endpoint for the ACR | `bool` | `false` | no |
| create\_aks\_user\_identity | Flag to create AKS user-assigned identity. | `bool` | `true` | no |
| create\_frontdoor | Whether to create the Azure Front Door | `bool` | `true` | no |
| create\_keyvault | Whether to create a Key Vault resource. | `bool` | `false` | no |
| create\_postgresql | Whether to create the PostgreSQL Flexible Server | `bool` | `true` | no |
| demo\_app\_hostname | Hostname for the demo app ingress, must match Front Door origin\_host\_header | `string` | `"demo-app.internal.fivebelow.com"` | no |
| deploy\_demo\_app | Whether to deploy the demo application for testing App Routing ingress with PLS | `bool` | `false` | no |
| dns\_service\_ip | The DNS service IP for the AKS cluster. | `string` | `""` | no |
| enable\_agic | Whether to enable the AGIC addon on AKS with a brown-field Application Gateway v2 | `bool` | `false` | no |
| enable\_agw\_private\_only | Register the EnableApplicationGatewayNetworkIsolation feature flag on the subscription.<br/>This enables private-IP-only Application Gateway v2 deployments (no public IP required).<br/>Requires AGIC v1.7+ and subnet delegation to Microsoft.Network/applicationGateways.<br/>Docs: https://learn.microsoft.com/en-us/azure/application-gateway/application-gateway-private-deployment | `bool` | `false` | no |
| enable\_private\_link\_ingress | Whether to create an internal ingress controller with Private Link Service for Front Door connectivity.<br/>Uses kubectl\_manifest (gavinbunney/kubectl) which supports single-apply — no phased deployment needed. | `bool` | `false` | no |
| environment | Environment name | `string` | n/a | yes |
| frontdoor\_logs\_destinations\_ids | List of destination resource IDs for sending Front Door logs | `list(string)` | `[]` | no |
| frontdoor\_response\_timeout\_seconds | Specifies the maximum response timeout in seconds. Possible values are between `16` and `240` seconds (inclusive). | `number` | `120` | no |
| frontdoor\_sku\_name | Specifies the SKU for this Azure CDN FrontDoor profile. Possible values include `Standard_AzureFrontDoor` and `Premium_AzureFrontDoor`. | `string` | `"Premium_AzureFrontDoor"` | no |
| ingress\_private\_endpoint | Private Link Service subnet for the Ingress | `string` | `"subn-privateendpoint-1"` | no |
| ingress\_subnet\_name | Ingress subnet for internal load balancer | `string` | `"subn-system-node-1"` | no |
| keyvault\_enabled\_for\_deployment | Whether Azure VMs can retrieve certificates from the Key Vault. | `bool` | `false` | no |
| keyvault\_enabled\_for\_disk\_encryption | Whether Azure Disk Encryption can retrieve secrets and unwrap keys. | `bool` | `false` | no |
| keyvault\_enabled\_for\_template\_deployment | Whether Azure Resource Manager can retrieve secrets from the Key Vault. | `bool` | `false` | no |
| keyvault\_purge\_protection\_enabled | Whether purge protection is enabled. Recommended for production. | `bool` | `true` | no |
| keyvault\_sku | The SKU of the Key Vault. Possible values are 'standard' or 'premium'. | `string` | `"standard"` | no |
| keyvault\_soft\_delete\_retention\_days | The number of days to retain soft-deleted keys (7-90). | `number` | `90` | no |
| log\_analytics\_daily\_quota\_gb | The daily quota limit, when this is reached no more data ingestion until the quota is reset at midnight. `null` = no limit | `number` | `null` | no |
| log\_analytics\_internet\_ingestion\_enabled | Should the Log Analytics Workspace support ingestion over the Public Internet | `bool` | `false` | no |
| log\_analytics\_retention\_in\_days | The data retention in days. | `number` | `30` | no |
| log\_analytics\_sku | The SKU of the Log Analytics Workspace. | `string` | `"PerGB2018"` | no |
| lz\_short\_code | A short code for the LZ to use in naming of resources. | `string` | n/a | yes |
| network\_policy | Network policy plugin for AKS. Set to 'azure' for Azure NPM or 'calico' for Calico. null disables network policies. | `string` | `"azure"` | no |
| only\_critical\_addons\_enabled | (Optional) Enabling this option will taint the default (system) node pool with<br/>`CriticalAddonsOnly=true:NoSchedule` taint. Only Kubernetes system services can<br/>schedule on the system node pool. User workloads will only run on the user node pool.<br/>WARNING: Changing this forces a new node pool to be created. | `bool` | `true` | no |
| paired\_region\_pe\_subnet\_name | The subnet name for private endpoints in the paired region | `string` | `null` | no |
| paired\_region\_private\_dns\_zone\_resource\_group\_name | The resource group name where the paired region private DNS zones are located | `string` | `null` | no |
| paired\_region\_vnet\_name | The VNet name in the paired region | `string` | `null` | no |
| paired\_region\_vnet\_resource\_group\_name | The resource group name for the VNet in the paired region | `string` | `null` | no |
| postgresql\_admin\_group\_name | Display name of the Entra ID group for PostgreSQL administrators | `string` | `null` | no |
| postgresql\_admin\_group\_object\_id | Optional object ID override for the Entra ID group. If null, object\_id is resolved via data.azuread\_group using postgresql\_admin\_group\_name. | `string` | `null` | no |
| postgresql\_admin\_principal\_type | Principal type for PostgreSQL Entra ID admin. This template uses Group-based administration. | `string` | `"Group"` | no |
| postgresql\_availability\_zone | Availability zone for primary server (1, 2, or 3). Required for production HA. | `string` | `null` | no |
| postgresql\_backup\_retention\_days | Backup retention days (7-35). Prod should use 35. | `number` | `7` | no |
| postgresql\_fallback\_admin\_user\_principal\_name | Fallback Entra ID user principal name used when the PostgreSQL admin group lookup has no match. | `string` | n/a | yes |
| postgresql\_geo\_redundant\_backup\_enabled | Enable geo-redundant backups. Recommended for production. | `bool` | `false` | no |
| postgresql\_high\_availability | High availability configuration. Set to { mode = 'ZoneRedundant', standby\_availability\_zone = '2' } for production. | <pre>object({<br/>    mode                      = string<br/>    standby_availability_zone = optional(string)<br/>  })</pre> | `null` | no |
| postgresql\_sku\_name | PostgreSQL SKU name. Dev/Test: B\_Standard\_B1ms, Prod: GP\_Standard\_D4s\_v3 | `string` | `"B_Standard_B1ms"` | no |
| postgresql\_storage\_mb | PostgreSQL storage size in MB (32768 = 32GB) | `number` | `32768` | no |
| postgresql\_version | PostgreSQL version (17 is current stable) | `string` | `"17"` | no |
| private\_link\_dns\_zones | Map of private DNS zones | <pre>map(object({<br/>    zone_name = string<br/>  }))</pre> | <pre>{<br/>  "acr": {<br/>    "zone_name": "privatelink.azurecr.io"<br/>  },<br/>  "aks": {<br/>    "zone_name": "privatelink.{regionName}.azmk8s.io"<br/>  },<br/>  "blob": {<br/>    "zone_name": "privatelink.blob.core.windows.net"<br/>  },<br/>  "keyvault": {<br/>    "zone_name": "privatelink.vaultcore.azure.net"<br/>  },<br/>  "postgresql": {<br/>    "zone_name": "privatelink.postgres.database.azure.com"<br/>  }<br/>}</pre> | no |
| service\_cidr | The service CIDR for the AKS cluster. | `string` | `""` | no |
| sys\_np\_max\_count | The maximum number of nodes for the system node pool. | `number` | `1` | no |
| sys\_np\_min\_count | The minimum number of nodes for the system node pool. | `number` | `1` | no |
| sys\_np\_node\_count | Initial number of nodes for the system node pool. | `number` | `1` | no |
| sys\_np\_node\_vm\_size | The VM size for the system node pool. | `string` | `"Standard_D2ds_v5"` | no |
| usr\_np\_max\_count | The maximum number of nodes for the user node pool. | `number` | `1` | no |
| usr\_np\_min\_count | The minimum number of nodes for the user node pool. | `number` | `1` | no |
| usr\_np\_node\_count | Initial number of nodes for the user node pool. | `number` | `1` | no |
| usr\_np\_node\_vm\_size | The VM size for the user node pool. | `string` | `"Standard_D2ds_v5"` | no |
| vnet\_address\_space | The address space applied to the virtual network. You can supply more than one address space. | `list(string)` | n/a | yes |
| vnet\_nsg\_rules | A map of NSG rules to create. | <pre>map(object({<br/>    name                       = string<br/>    priority                   = number<br/>    direction                  = string<br/>    access                     = string<br/>    protocol                   = string<br/>    source_port_range          = string<br/>    destination_port_range     = string<br/>    source_address_prefix      = string<br/>    destination_address_prefix = string<br/>  }))</pre> | `{}` | no |
| vnet\_routes | (Optional) A map of route objects to create on the route table. | <pre>map(object({<br/>    name                   = string<br/>    address_prefix         = string<br/>    next_hop_type          = string<br/>    next_hop_in_ip_address = optional(string)<br/>  }))</pre> | `{}` | no |
| vnet\_subnets | A map of subnets to create. | <pre>map(object({<br/>    name                                          = string<br/>    address_prefixes                              = list(string)<br/>    nsg_rule_names                                = list(string)<br/>    default_outbound_access_enabled               = optional(bool, false)<br/>    route_names                                   = optional(list(string), [])<br/>    private_link_service_network_policies_enabled = optional(bool, true)<br/>    delegation = optional(list(object({<br/>      name = string<br/>      service_delegation = object({<br/>        name = string<br/>      })<br/>    })), [])<br/>  }))</pre> | n/a | yes |
| workload\_identity\_enabled | Enabling workload identity for aks cluster | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| acr\_id | The resource ID of the Azure Container Registry |
| acr\_login\_server | The login server URL of the Azure Container Registry |
| acr\_name | The name of the Azure Container Registry |
| acr\_resource\_group\_name | The resource group name for the Azure Container Registry |
| agic\_enabled | Whether the AGIC addon is enabled on the AKS cluster |
| aks\_cluster\_id | The resource ID of the AKS cluster |
| aks\_cluster\_name | The name of the AKS cluster |
| aks\_resource\_group\_name | The resource group name for the AKS cluster |
| appgw\_subnet\_cidr | CIDR of the Application Gateway subnet (AGIC) |
| application\_gateway\_id | The ID of the Terraform-managed Application Gateway used by AGIC |
| application\_gateway\_name | The name of the Terraform-managed Application Gateway used by AGIC |
| application\_gateway\_public\_ip | The public IP address of the Application Gateway (null when private-only) |
| frontdoor\_profile\_id | The resource ID of the Azure Front Door profile |
| frontdoor\_profile\_name | The name of the Azure Front Door profile |
| frontdoor\_resource\_group\_name | The resource group name where the Front Door profile is deployed |
| frontdoor\_sku\_name | The SKU of the Azure Front Door profile |
| ingress\_application\_gateway | The AKS cluster's AGIC Application Gateway details (name, ID, identity) |
| keyvault\_id | Key Vault resource ID |
| keyvault\_name | Key Vault name |
| keyvault\_uri | Key Vault URI |
| pls\_name | The name of the Private Link Service created by AKS App Routing |
| postgresql\_connection\_info | Connection information for applications |
| postgresql\_server\_fqdn | Fully qualified domain name of the PostgreSQL server |
| postgresql\_server\_id | PostgreSQL Flexible Server resource ID |
| postgresql\_server\_name | PostgreSQL Flexible Server name |
| postgresql\_subnet\_cidr | CIDR of the PostgreSQL delegated subnet |
| private\_endpoint\_subnet\_cidr | CIDR of the private endpoint subnet (ACR, Storage, Key Vault) |
| private\_endpoint\_subnet\_id | Subnet resource ID used for private endpoints in the core virtual network |
<!-- END_TF_DOCS -->
