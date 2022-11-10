variable "pgsql_administrator_login_password" {
  description = "The admin password"
}

# Provision Intel Optimized Azure PostgreSQL server 
module "optimized-pgsql-server" {
  source                             = "../"              #add the github url later
  resource_group_name                = "shreejan_test_mssql"
  pgsql_server_name                  = "optimized-pgsql-server-test"
  pgsql_db_name                      = "optimized-pgsql-db-test"
  pgsql_administrator_login_password = var.pgsql_administrator_login_password
  tags                               = {
                                            "duration" = 2,
                                            "owner"    = "shreejan.mistry@intel.com"
                                       }

  firewall_ip_range                  =  [
                                            {start_ip_address = "192.55.54.53",end_ip_address = "192.55.54.53" },
                                            {start_ip_address = "250.151.84.219",end_ip_address = "250.151.84.219" },
                                            {start_ip_address = "79.4.142.148",end_ip_address = "79.4.142.148"}
                                         ]
}




#terraform init  
#terraform plan -var="pgsql_administrator_login_password=..." #Enter a complex password
#terraform apply -var="pgsql_administrator_login_password=..." #Enter a complex password