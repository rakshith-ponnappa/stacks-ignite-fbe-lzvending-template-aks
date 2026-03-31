component_names = ["networking", "azcr", "afd", "aks", "monitor", "identity", "postgresql", "keyvault"]

# PostgreSQL Entra ID Administrator
# Group name resolves from data.azuread_group.postgresql_admin when object_id is null
postgresql_admin_group_name                   = "fb-postgress-admin-__APPLICATION_NAME__"
postgresql_admin_principal_type               = "Group"
postgresql_admin_group_object_id              = null
postgresql_fallback_admin_user_principal_name = "zz_spr.ext@fivebelow.com"

# Tagging
ProductDomain   = "Enterprise"
Application     = "Management Landing Zone"
ApplicationCode = "123"
Environment     = "Production"
Role            = "Management"
Criticality     = "High"
CostCode        = "CC12345"
Owner           = "user@fivebelow.com"
CreatedOn       = "2024-10-01"
CreatedBy       = "user@fivebelow.com"
Monitoring      = "AzureMonitor"
