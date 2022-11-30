module "optimized-postgres-server" {
  source              = "github.com/intel/terraform-intel-azure-postgresql_flexible_server"
  resource_group_name = "terraform-testing-rg"
  db_server_name      = "testingserver25"
  db_password         = var.db_password
  tags = {
    Owner       = "John Doe"
    Application = "App Database"
  }
}

