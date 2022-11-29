module "optimized-postgres-server" {
  source              = "../../"
  resource_group_name = "resource_group_name"              # Required
  db_server_name      = "optimized-postgres-server" #  Required
  db_password         = var.db_password             # Required
  db_ha_mode          = "ZoneRedundant"             # Optional
  db_name             = "test-db"                   # Optional
  tags = {
    name    = "name"
    purpose = "intel"
  }

  db_parameters = {
    postgres = {

      autovacuum_work_mem = {
        value = "-1"
      }
      checkpoint_completion_target = {
        value = "0.9"
      }
      work_mem = {
        value = "2097151"
      }
    }
  }

}
