module "optimized-postgres-server" {
  source              = "intel/azure-postgresql-flexible-server/intel"
  resource_group_name = "resource_group_name" # Required
  db_server_name      = "mysetestingserver34" # Required
  db_password         = var.db_password       # Required
  db_ha_mode          = "ZoneRedundant"
  db_name             = "test-db1"
  tags = {
    Owner       = "John Doe"
    Application = "App Database"
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

