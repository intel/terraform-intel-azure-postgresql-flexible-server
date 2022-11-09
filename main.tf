data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

resource "azurerm_postgresql_flexible_server" "postgresql_flexible" {
  name                   = var.pgsql_server_name
  resource_group_name    = data.azurerm_resource_group.rg.name
  location               = data.azurerm_resource_group.rg.location
  version                = var.pgsql_version
  administrator_login    = var.pgsql_administrator_login
  administrator_password = var.pgsql_administrator_login_password
  create_mode            = var.create_mode
  # delegated_subnet_id          = data.azurerm_subnet.subnet.id
  sku_name   = var.pgsql_server_sku
  storage_mb = var.storage_mb
  tags = merge(
    var.tags,
    {
      "Intel Cloud Optimization Module" = "Azure PostgreSQL Flexible"
    }
  )
}

resource "azurerm_postgresql_flexible_server_database" "postgresql_flexible_db" {
  name      = var.pgsql_db_name
  server_id = azurerm_postgresql_flexible_server.postgresql_flexible.id
  collation = "en_US.utf8"
  charset   = "utf8"
}

resource "azurerm_postgresql_flexible_server_firewall_rule" "example" {
  count            = length(var.firewall_ip_range) == 0 ? 0 : length(var.firewall_ip_range)
  name             = "pgsql_firewall_rule${count.index}"
  server_id        = azurerm_postgresql_flexible_server.postgresql_flexible.id
  start_ip_address = var.firewall_ip_range[count.index]["start_ip_address"]
  end_ip_address   = var.firewall_ip_range[count.index]["end_ip_address"]
}

resource "azurerm_postgresql_flexible_server_configuration" "pgsql_server_config" {
  for_each  = var.pgsql_configuration != null ? { for k, v in var.pgsql_configuration : k => v if v != null } : {}
  name      = each.key
  server_id = azurerm_postgresql_flexible_server.postgresql_flexible.id
  value     = each.value
}

