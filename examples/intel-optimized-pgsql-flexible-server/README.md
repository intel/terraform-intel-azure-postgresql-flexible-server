<p align="center">
  <img src="https://github.com/intel/terraform-intel-azure-postgresql-flexible-server/blob/main/images/logo-classicblue-800px.png?raw=true" alt="Intel Logo" width="250"/>
</p>

# Intel Cloud Optimization Modules for Terraform

© Copyright 2022, Intel Corporation

## Intel Optimized Azure PostgreSQL Flexible Server Module Example

This module can be used to deploy an Intel optimized Azure PostgreSQL Flexible Server instance.
Instance selection and pgsql optimization are included by default in the code.

The PostgreSQL Optimizations were based off [Intel Xeon Tunning guides](<https://www.intel.com/content/www/us/en/developer/articles/guide/open-source-database-tuning-guide-on-xeon-systems.html>)

## Usage

By default, you will only have to pass three variables

```hcl
resource_group_name    
db_server_name       
db_password         
```

variables.tf

```hcl
variable "db_password" {
  description = "Password for the master database user."
  type        = string
  sensitive   = true
}
```

main.tf

```hcl
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


```

Run Terraform

```hcl
export TF_VAR_db_password ='<USE_A_STRONG_PASSWORD>'

terraform init  
terraform plan
terraform apply 
```

## Considerations

If you see this error message below, this is because the pgsql_server_name already exist and the user needs to provide different unique pgsql_server_name.

```hcl
Error Message ::: " Server Name: "optimized-pgsql-server"): polling after Create: Code="ServerGroupDropping" Message="Operations on a server group in dropping state are not allowed."
```

If you see this error message below, this is because the High Avability Mode is disabled for that region. Acceptable regions are [Azure Region](<https://learn.microsoft.com/en-us/azure/postgresql/flexible-server/overview#azure-regions>)

```hcl
Error Message ::: "Server Name: "optimized-postgres-server"): polling after Create: Code="HADisabledForRegion" Message="HA is disabled for region westus2.""
```

This module further provides the ability to add firewall_ip_range (Usage Example provided above). For more information [azurerm_postgresql_flexible_server_firewall_rule](<https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server_firewall_rule>)

Note that this example creates resources. Run `terraform destroy` when you don't need these resources.