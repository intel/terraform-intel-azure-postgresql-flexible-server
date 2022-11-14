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

# Intel Cloud Optimization Module for PostgreSQL optimizations  
variable "pgsql_configuration" {
  description = "PostgreSQL Server Optimizations"
  type        = map(string)
  default = {
    "max_connections"              = 256,
    "shared_buffers"               = 64000,
    "huge_pages"                   = "on",
    "temp_buffers"                 = 4000,
    "work_mem"                     = 2097151,
    "maintenance_work_mem"         = 512000,
    "autovacuum_work_mem"          = -1,
    "effective_io_concurrency"     = 32,
    "wal_level"                    = "logical",
    "wal_buffers"                  = 512,
    "cpu_tuple_cost"               = 0.03,
    "effective_cache_size"         = 350000000,
    "random_page_cost"             = 1.1,
    "checkpoint_timeout"           = 3600,
    "checkpoint_completion_target" = 0.9,
    "checkpoint_warning"           = 1,
    "log_min_messages"             = "error",
    "log_min_error_statement "     = "error",
    "autovacuum"                   = "on",
    "autovacuum_max_workers"       = 10,
    "autovacuum_vacuum_cost_limit" = 3000,
    "datestyle"                    = "ISO, DMY",
    "lc_monetary"                  = "en_US.UTF-8",
    "lc_numeric"                   = "en_US.UTF-8",
    "default_text_search_config"   = "pg_catalog.english",
    "max_locks_per_transaction"    = 64,
    "max_wal_senders"              = 5,
    "min_wal_size"                 = 8192,
    "max_wal_size"                 = 524


    /* This parameter is READ-Only in Azure Portal and defaults to ON. */

    # "synchronous_commit"   = "on",   

    /* The set of PostgreSQL configuration parameter are available and recommended on the Xeon Tunning Guide,
        but as of right now, configuration of this parameters ((given below) is not supported. */

    # "max_stack_depth"     = 7,
    # "dynamic_shared_memory_type" = "posix",
    # "max_files_per_process" = 4000,
    # "max_pred_locks_per_transaction" = 64,
    # "archive_mode" = "off",
    # "lc_time" = "en_US.UTF-8",
    # "lc_messages" = "en_US.UTF-8",
  }

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
  description = "PostgreSQL Database name"
  type        = string
}

#The version of PostgreSQL Flexible Server to use. Possible values are 11,12, 13 and 14. Required when create_mode is Default. Changing this forces a new PostgreSQL Flexible Server to be created.
variable "pgsql_version" {
  description = "PostgreSQL Version"
  type        = string
  validation {
    condition     = contains(["11", "12", "13", "14"], var.pgsql_version)
    error_message = "The pgsql_version must be one of the following: \"11\",\"12\",\"13\", or \"14\"."
  }
  default = "13" #ASK LUCAS
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

#Capacity of the PostgreSQL
variable "storage_mb" {
  description = "The max storage allowed for the PostgreSQL Flexible Server. Possible values (MB) are 32768, 65536, 131072, 262144, 524288, 1048576, 2097152, 4194304, 8388608, and 16777216."
  type        = number
  default     = 32768
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
    start_ip_address = string
    end_ip_address   = string
  }))
  description = "User will provide range of IP addrress in form of List of (objects)"
  default     = []
}
