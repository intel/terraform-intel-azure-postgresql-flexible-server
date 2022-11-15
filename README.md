<p align="center">
  <img src="./images/logo-classicblue-800px.png" alt="Intel Logo" width="250"/>
</p>

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
->>> If you see this error message below, this is because the pgsql_server_name already exist and the user needs to provide different unique pgsql_server_name.
```hcl 
Error Message ::: " Server Name: "optimized-pgsql-server"): polling after Create: Code="ServerGroupDropping" Message="Operations on a server group in dropping state are not allowed."

```

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


<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.2.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~>3.26.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~>3.26.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_postgresql_flexible_server.postgresql_flexible](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server) | resource |
| [azurerm_postgresql_flexible_server_configuration.pgsql_server_config](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server_configuration) | resource |
| [azurerm_postgresql_flexible_server_database.postgresql_flexible_db](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server_database) | resource |
| [azurerm_postgresql_flexible_server_firewall_rule.example](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server_firewall_rule) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_mode"></a> [create\_mode](#input\_create\_mode) | The creation mode which can be used to restore or replicate existing servers. Possible values are Default and PointInTimeRestore. Changing this forces a new PostgreSQL Flexible Server to be created. | `string` | `"Default"` | no |
| <a name="input_firewall_ip_range"></a> [firewall\_ip\_range](#input\_firewall\_ip\_range) | User will provide range of IP addrress in form of List of (objects) | <pre>list(object({<br>    start_ip_address = string<br>    end_ip_address   = string<br>  }))</pre> | `[]` | no |
| <a name="input_pgsql_administrator_login"></a> [pgsql\_administrator\_login](#input\_pgsql\_administrator\_login) | PostgreSQL server name admin username | `string` | `"pgsqladmin"` | no |
| <a name="input_pgsql_administrator_login_password"></a> [pgsql\_administrator\_login\_password](#input\_pgsql\_administrator\_login\_password) | PostgreSQL server name admin password | `string` | n/a | yes |
| <a name="input_pgsql_configuration"></a> [pgsql\_configuration](#input\_pgsql\_configuration) | PostgreSQL Server Optimizations | `map(string)` | <pre>{<br>  "autovacuum": "on",<br>  "autovacuum_max_workers": 10,<br>  "autovacuum_vacuum_cost_limit": 3000,<br>  "autovacuum_work_mem": -1,<br>  "checkpoint_completion_target": 0.9,<br>  "checkpoint_timeout": 3600,<br>  "checkpoint_warning": 1,<br>  "cpu_tuple_cost": 0.03,<br>  "datestyle": "ISO, DMY",<br>  "default_text_search_config": "pg_catalog.english",<br>  "effective_cache_size": 350000000,<br>  "effective_io_concurrency": 32,<br>  "huge_pages": "on",<br>  "lc_monetary": "en_US.UTF-8",<br>  "lc_numeric": "en_US.UTF-8",<br>  "log_min_error_statement ": "error",<br>  "log_min_messages": "error",<br>  "maintenance_work_mem": 512000,<br>  "max_connections": 256,<br>  "max_locks_per_transaction": 64,<br>  "max_wal_senders": 5,<br>  "max_wal_size": 524,<br>  "min_wal_size": 8192,<br>  "random_page_cost": 1.1,<br>  "shared_buffers": 64000,<br>  "temp_buffers": 4000,<br>  "wal_buffers": 512,<br>  "wal_level": "logical",<br>  "work_mem": 2097151<br>}</pre> | no |
| <a name="input_pgsql_db_name"></a> [pgsql\_db\_name](#input\_pgsql\_db\_name) | PostgreSQL Database name | `string` | n/a | yes |
| <a name="input_pgsql_server_name"></a> [pgsql\_server\_name](#input\_pgsql\_server\_name) | PostgreSQL server name | `string` | n/a | yes |
| <a name="input_pgsql_server_sku"></a> [pgsql\_server\_sku](#input\_pgsql\_server\_sku) | The SKU Name for the PostgreSQL Flexible Server. The name of the SKU, follows the tier + name pattern (e.g. B\_Standard\_B1ms, GP\_Standard\_D2s\_v3, MO\_Standard\_E4s\_v3). | `string` | `"MO_Standard_E8ds_v4"` | no |
| <a name="input_pgsql_version"></a> [pgsql\_version](#input\_pgsql\_version) | PostgreSQL Version | `string` | `"13"` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Existing Resource Group where resource will be created. | `string` | n/a | yes |
| <a name="input_storage_mb"></a> [storage\_mb](#input\_storage\_mb) | The max storage allowed for the PostgreSQL Flexible Server. Possible values (MB) are 32768, 65536, 131072, 262144, 524288, 1048576, 2097152, 4194304, 8388608, and 16777216. | `number` | `32768` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_postgresql_fqdn"></a> [postgresql\_fqdn](#output\_postgresql\_fqdn) | The FQDN of the PostgreSQL Flexible Server. |
| <a name="output_postgresql_id"></a> [postgresql\_id](#output\_postgresql\_id) | The ID of the PostgreSQL Flexible Server. |
| <a name="output_postgresql_public_network_access_enabled"></a> [postgresql\_public\_network\_access\_enabled](#output\_postgresql\_public\_network\_access\_enabled) | Is public network access enabled? |
<!-- END_TF_DOCS -->