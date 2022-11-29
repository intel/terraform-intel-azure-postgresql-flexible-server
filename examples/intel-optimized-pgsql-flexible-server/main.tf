module "optimized-postgres-server" {
  source              = "../../"
  resource_group_name = "<YOUR-RG-ID>"              # Required
  db_server_name      = "optimized-postgres-server" #  Required
  db_password         = var.db_password             # Required
  db_ha_mode          = "ZoneRedundant"             # Optional
  db_name             = "test-db"                   # Optional
  tags = {
    name    = "name"
    purpose = "intel"
  }
  # Optional but I need someone to do testing with these.
  db_firewall_rules = [
    {
      end_ip_address   = "0.0.0.0"
      name             = "Azure-all-services"
      start_ip_address = "0.0.0.0"
    },
    {
      end_ip_address   = "172.16.1.254"
      name             = "Test-Rule"
      start_ip_address = "172.16.1.1"
    }
  ]
}
