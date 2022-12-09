module "optimized-postgres-server" {
  source              = "intel/azure-postgresql-flexible-server/intel"
  resource_group_name = "terraform-testing-rg"
  db_server_name      = "testingserver25"
  db_password         = var.db_password
  tags = {
    Owner       = "John Doe"
    Application = "App Database"
  }
}

