output "id" {
  value = azurerm_postgresql_flexible_server.postgresql_flexible.id
}

output "fqdn" {
  value = azurerm_postgresql_flexible_server.postgresql_flexible.fqdn
}

output "public_network_access_enabled" {
  value = azurerm_postgresql_flexible_server.postgresql_flexible.public_network_access_enabled
}
