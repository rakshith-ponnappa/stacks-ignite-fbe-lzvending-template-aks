# Azure PostgreSQL Flexible Server Module

This module wraps the Azure Verified Module (AVM) for PostgreSQL Flexible Server with enterprise defaults.

## Features

- **Entra ID Only Authentication** - No password authentication
- **Private Network Access** - VNet integration or Private Endpoints
- **Secure Defaults** - No public access, no firewall rules
- **High Availability** - ZoneRedundant or SameZone options
- **Geo-Redundant Backups** - For production environments
- **Diagnostic Settings** - Log Analytics integration

## Usage

```hcl
module "postgresql" {
  source = "./modules/az_postgresql"

  postgresql_server_name = "psql-eus2-fb-prd-app-001"
  resource_group_name    = "rg-eus2-fb-prd-postgresql-001"
  location               = "eastus2"

  # Authentication - Entra ID Only
  tenant_id = data.azurerm_client_config.current.tenant_id
  ad_administrators = {
    "infra_admins" = {
      tenant_id      = data.azurerm_client_config.current.tenant_id
      object_id      = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
      principal_name = "pg-admins-group"
      principal_type = "Group"
    }
  }

  # Networking - VNet Integration
  delegated_subnet_id = module.network.subnets["subn-postgresql"].resource_id
  private_dns_zone_id = data.azurerm_private_dns_zone.postgresql.id

  # Compute
  sku_name           = "GP_Standard_D4s_v3"
  storage_mb         = 131072
  postgresql_version = "17"

  # High Availability (Production)
  high_availability = {
    mode                      = "ZoneRedundant"
    standby_availability_zone = "2"
  }
  availability_zone = "1"

  # Backup
  backup_retention_days        = 35
  geo_redundant_backup_enabled = true

  # Monitoring
  diagnostic_settings = {
    "log_analytics" = {
      workspace_resource_id = module.log_analytics.resource_id
    }
  }

  # Lock (Production)
  lock = {
    kind = "CanNotDelete"
  }

  tags = module.tagging.resource_tags
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| postgresql_server_name | Name of the PostgreSQL server | string | - | yes |
| location | Azure region | string | - | yes |
| resource_group_name | Resource group name | string | - | yes |
| tenant_id | Entra ID tenant ID | string | - | yes |
| ad_administrators | Entra ID administrators | map(object) | - | yes |
| delegated_subnet_id | Subnet for VNet integration | string | null | no |
| private_dns_zone_id | Private DNS zone ID | string | null | no |
| sku_name | SKU name | string | "GP_Standard_D2s_v3" | no |
| storage_mb | Storage size in MB | number | 32768 | no |
| postgresql_version | PostgreSQL version | string | "17" | no |
| high_availability | HA configuration | object | null | no |
| backup_retention_days | Backup retention (7-35) | number | 7 | no |
| geo_redundant_backup_enabled | Enable GRS backups | bool | false | no |

## Outputs

| Name | Description |
|------|-------------|
| postgresql_server_id | Server resource ID |
| postgresql_server_name | Server name |
| postgresql_server_fqdn | Fully qualified domain name |
| postgresql_connection_info | Connection details for apps |

## Authentication

This module enforces **Entra ID only** authentication. Password authentication is disabled for security.

Applications should use:
- **Workload Identity** - For AKS pods
- **Managed Identity** - For Azure services
- **Service Principal** - For automation/pipelines

## Network Integration

Two options are supported (mutually exclusive):

1. **VNet Integration** (Recommended)
   - Uses delegated subnet
   - Requires Private DNS zone
   - Server is injected into VNet

2. **Private Endpoints**
   - Uses private endpoint subnet
   - Supports cross-VNet access
   - More flexible networking

## Related Modules

- `az_postgresql_database` - For app-level database creation
