#------------------------------------------------------------------------------
# OUTPUTS - Used by App modules via remote state
#------------------------------------------------------------------------------

output "postgresql_server_id" {
  value       = module.postgresql.resource_id
  description = "PostgreSQL Flexible Server resource ID"
}

output "postgresql_server_name" {
  value       = module.postgresql.name
  description = "PostgreSQL Flexible Server name"
}

output "postgresql_server_fqdn" {
  value       = module.postgresql.fqdn
  description = "Fully qualified domain name of the PostgreSQL server"
}

output "postgresql_database_ids" {
  value       = module.postgresql.database_resource_ids
  description = "Map of database names to resource IDs (if any created in core)"
}

output "postgresql_database_names" {
  value       = module.postgresql.database_name
  description = "Map of database keys to database names"
}

output "postgresql_connection_info" {
  value = {
    server_id   = module.postgresql.resource_id
    server_name = module.postgresql.name
    server_fqdn = module.postgresql.fqdn
    port        = 5432
    ssl_mode    = "require"
    auth_method = "EntraID"
  }
  description = "Connection information for applications"
}
