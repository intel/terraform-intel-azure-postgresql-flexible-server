## Terraform Module Acclerated by Intel for Azure PostgreSQL Flexible Server
This module can be used to deploy an Intel optimized Azure PostgreSQL Flexible Server instance. 

Instance selection and configuration are included by default in the code. 

Xeon Tunning guide

<https://www.intel.com/content/www/us/en/developer/articles/guide/open-source-database-tuning-guide-on-xeon-systems.html>



## Usage

See examples folder for code ./examples/main.tf



By default, you will only have to pass three variables

```hcl
resource_group_name 
mssql_server_name  
mssql_db_name 
mssql_administrator_login_password 

```

Example of Error:
Error Message ::: " Server Name: "optimized-pgsql-server"): polling after Create: Code="ServerGroupDropping" Message="Operations on a server group in dropping state are not allowed." " 
->>> If you see this error message above, this is because the pgsql_server_name already exist and the user needs to provide  different unique name

Example of main.tf
```hcl
# main.tf

variable "mssql_administrator_login_password" {
  description = "The admin password"
}

# Provision Intel Optimized Azure PostgreSQL server 
module "optimized-pgsql-server" {
  source                             = "../"              #add the github url later
  resource_group_name                = "ENTER_RG_NAME_HERE"
  pgsql_server_name                  = "ENTER_PGSQL_SERVER_NAME_HERE"
  pgsql_db_name                      = "ENTER_PGSQL_DB_NAME_HERE"
  pgsql_administrator_login_password = var.pgsql_administrator_login_password
  tags                               = {"ENTER_TAG_KEY" = "ENTER_TAG_VALUE", ... }                      #Can add tags as key-value pair

  #firewall_ip_ranges
  #For example: " [{start_ip_address = ..., end_ip_address = ... },..]"
  firewall_ip_range                 =  [
                                            {start_ip_address = "ENTER_START_IP_ADDRESS_HERE", end_ip_address = "ENTER_END_IP_ADDRESS_HERE" },...
}



```
Run terraform
```
terraform init  
terraform plan -var="mssql_administrator_login_password=..." #Enter a complex password
terraform apply -var="mssql_administrator_login_password=..." #Enter a complex password

```
## Considerations
This module further provides the ability to add firewall_ip_range (Usage Example provided above). For more information : https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server_firewall_rule

