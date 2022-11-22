locals {
  # Determine if the db_engine is set to mysql. If true then create a list of all the backup strings, if false then create an empty list. This list is referenced to determine the length which acts like a flag for the dynamic block
  ha_flag = var.db_engine == "postgres" ? compact([var.db_ha_standby_zone, var.db_ha_mode]) : []

  # Evaluates if a parameter wasn't supplied in the input map (someone didn't want to use it) and returns only the objects that have been configured
  db_parameters = { for parameter, value in lookup(var.db_parameters, var.db_engine, {}) : parameter => value if value != null /* object */ }

  # Determine if the db_engine is set to mysql. If true then create a list of all the maintenance strings, if false then create an empty list. This list is referenced to determine the length which acts like a flag for the dynamic block
  maintenance_flag = var.db_engine == "postgres" ? compact([var.db_maintenance_day, var.db_maintenance_hour, var.db_maintenance_minute]) : []


  # Firewall rules that are converted from a list of a map. Setting the name of the rule to the key and reconstructing it so we can use for_each instead of count
  firewall_rules = {
    for rule, value in var.db_firewall_rules : value.name => {
      start_ip_address = value.start_ip_address
      end_ip_address   = value.end_ip_address
    }
  }
}

data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

resource "azurerm_postgresql_flexible_server" "postgres" {
  name                   = var.db_server_name
  resource_group_name    = data.azurerm_resource_group.rg.name
  location               = data.azurerm_resource_group.rg.location
  version                = var.db_engine_version
  administrator_login    = var.db_username
  administrator_password = var.db_password
  create_mode            = var.db_create_mode
  sku_name               = var.db_server_sku
  storage_mb             = var.db_allocated_storage
  tags                   = var.tags

  # Backups
  backup_retention_days        = var.db_backup_retention_period
  geo_redundant_backup_enabled = var.db_geo_backup_enabled

  zone                = var.db_zone
  private_dns_zone_id = var.db_private_dns_zone_id
  delegated_subnet_id = var.db_private_dns_zone_id != null ? var.db_delegated_subnet_id : null


  source_server_id                  = var.db_create_source_id
  point_in_time_restore_time_in_utc = var.db_create_mode == "PointInTimeRestore" && var.db_create_source_id != null ? var.db_restore_time : null

  dynamic "maintenance_window" {
    for_each = length(local.maintenance_flag) >= 1 ? { "maintenance_flag" : "" } : {}
    content {
      day_of_week  = var.db_maintenance_day
      start_hour   = var.db_maintenance_hour
      start_minute = var.db_maintenance_minute
    }
  }

  dynamic "high_availability" {
    for_each = length(local.ha_flag) >= 1 ? { "ha_flag" : "" } : {}
    content {
      mode                      = var.db_ha_mode
      standby_availability_zone = var.db_ha_standby_zone
    }
  }

  timeouts {
    create = var.db_timeouts.create
    delete = var.db_timeouts.delete
    update = var.db_timeouts.update
  }

}

resource "azurerm_postgresql_flexible_server_database" "postgres" {
  count     = var.db_name != null ? 1 : 0
  name      = var.db_name
  server_id = azurerm_postgresql_flexible_server.postgres.id
  collation = var.db_collation
  charset   = var.db_charset

  timeouts {
    create = var.db_timeouts.create
    delete = var.db_timeouts.delete
    read   = var.db_timeouts.read
  }
}

resource "azurerm_postgresql_flexible_server_firewall_rule" "firewall" {
  for_each         = local.firewall_rules
  name             = each.key
  server_id        = azurerm_postgresql_flexible_server.postgres.id
  start_ip_address = each.value.start_ip_address
  end_ip_address   = each.value.end_ip_address
}

resource "azurerm_postgresql_flexible_server_configuration" "pgsql_server_config" {
  for_each  = local.db_parameters
  name      = each.key
  server_id = azurerm_postgresql_flexible_server.postgres.id
  value     = each.value.value
}