output "postgresql_id" {
  description = "The ID of the PostgreSQL Flexible Server."
  value       = module.optimized-pgsql-server.postgresql_id
}

output "postgresql_fqdn" {
  description = "The FQDN of the PostgreSQL Flexible Server."
  value       = module.optimized-pgsql-server.postgresql_fqdn
}

output "postgresql_public_network_access_enabled" {
  description = "Is public network access enabled?"
  value       = module.optimized-pgsql-server.postgresql_public_network_access_enabled
}
