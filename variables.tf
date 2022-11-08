#PostgreSQL Sever SKU 
#The Eds_v4-series run on the 3rd Generation Intel® Xeon® Platinum 8370C (Ice Lake), the Intel® Xeon® Platinum 8272CL (Cascade Lake) processors.
# We recommend Memory Optimized instances (2- 64 vCores) - MO_Standard_E2ds_v4, MO_Standard_E4ds_v4, MO_Standard_E8ds_v4, MO_Standard_E16ds_v4, MO_Standard_E20ds_v4, MO_Standard_E32ds_v4,MO_Standard_E48ds_v4, MO_Standard_E64ds_v4
# The number between E and d in MO_Standard_E8ds_v4 stands for vCores. 
# Ex.: MO_Standard_E8ds_v4-> 8 stands for vCPU count
# Azure Docs: https://learn.microsoft.com/en-us/azure/postgresql/flexible-server/concepts-compute-storage
variable "pgsql_server_sku" {
  description = "The SKU Name for the PostgreSQL Flexible Server. The name of the SKU, follows the tier + name pattern (e.g. B_Standard_B1ms, GP_Standard_D2s_v3, MO_Standard_E4s_v3)."
  default     = "MO_Standard_E8ds_v4"
}

#Resource Group Name
variable "resource_group_name" {
  description = "Resource Group where resource will be created. It should already exist"
  type        = string
}

#PostgreSQL Server Name 
variable "pgsql_server_name" {
  description = "PostgreSQL server name"
  type        = string
}

#PostgreSQL Database Name 
variable "pgsql_db_name" {
  description = "PostgreSQL Databas name"
  type        = string
}

#The version of PostgreSQL Flexible Server to use. Possible values are 11,12, 13 and 14. Required when create_mode is Default. Changing this forces a new PostgreSQL Flexible Server to be created.
variable "pgsql_version" {
  description = "PostgreSQL Version"
  type        = string
  default     = "13"   #ASK LUCAS
}

#PostgreSQL Server admin username 
variable "pgsql_administrator_login" {
  description = "PostgreSQL server name admin username"
  type        = string
  default     = "pgsqladmin"
}

#PostgreSQL Server admin password. Do not commit password to version control systems 
variable "pgsql_administrator_login_password" {
  description = "PostgreSQL server name admin password"
  type        = string
  sensitive   = true
}

#Mode of creation for PostgreSQL Server
variable "create_mode" {
  description = "The creation mode which can be used to restore or replicate existing servers. Possible values are Default and PointInTimeRestore. Changing this forces a new PostgreSQL Flexible Server to be created."
  type        = string 
  default     = "Default" 
}

#Subnet Name
variable "subnet_name"{
  description = "Specifies the name of the Subnet."
  type = string
  default = null
}

#Virtual Network Name 
variable "subnet_virtual_network_name"{
  description = "Specifies the name of the Virtual Network this Subnet is located within."
  type = string
  default = null
}

#Resource group name that the subnet is within
variable "subnet_resource_group_name"{
  description = "Specifies the name of the resource group the Virtual Network is located in."
  type = string
  default = null
}

#Capacity of the PostgreSQL
variable "storage_mb" {
  description = "The max storage allowed for the PostgreSQL Flexible Server. Possible values (MB) are 32768, 65536, 131072, 262144, 524288, 1048576, 2097152, 4194304, 8388608, and 16777216."
  type = number
  default = 32768
}

#Tags
variable "tags" {
  description = "Tags"
  type        = map(string)
  default     = {}
}

#For example:  [{start_ip_address = ..., end_ip_address = ... },..]"
variable "firewall_ip_range" {
  type = list(object({
    start_ip_address  = string
    end_ip_address    = string
  }))
  description = "User will provide range of IP adrress in form of List of (objects)"             
  default = [] 
}
