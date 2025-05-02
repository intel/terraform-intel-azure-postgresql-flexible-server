module "optimized-postgres-server" {
  source              = "intel/azure-postgresql-flexible-server/intel"
  resource_group_name = "<Your-ResourceGroup-Name>"
  db_server_name      = "<Your-Server-Name>"
  db_password         = var.db_password
  tags = {
    Owner       = "John Doe"
    Application = "App Database"
  }
}

