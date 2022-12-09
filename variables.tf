########################
####     Intel      ####
########################

# See policies.md, Intel recommends the Eds_v4-series running on the 3rd Generation Intel® Xeon® Platinum 8370C (Ice Lake), the Intel® Xeon® Platinum 8272CL (Cascade Lake) processors.
# General Purpose: GP_Standard_E2ds_v4, GP_Standard_E4ds_v4, GP_Standard_E8ds_v4, GP_Standard_E16ds_v4, GP_Standard_E20ds_v4, GP_Standard_E32ds_v4,GP_Standard_E48ds_v4, GP_Standard_E64ds_v4
# Memory Optimized: MO_Standard_E2ds_v4, MO_Standard_E4ds_v4, MO_Standard_E8ds_v4, MO_Standard_E16ds_v4, MO_Standard_E20ds_v4, MO_Standard_E32ds_v4,MO_Standard_E48ds_v4, MO_Standard_E64ds_v4
# The number between E and d in MO_Standard_E8ds_v4 stands for vCores. 
# Ex.: MO_Standard_E8ds_v4-> 8 stands for vCPU count
# See more:
# https://learn.microsoft.com/en-us/azure/postgresql/flexible-server/concepts-compute-storage

variable "db_server_sku" {
  description = "Instance SKU, see comments above for guidance"
  type        = string
  default     = "MO_Standard_E8ds_v4"
}

variable "db_parameters" {
  type = object({
    postgres = optional(object({
      max_connections = optional(object({
        value = optional(string, "256")
      }))
      shared_buffers = optional(object({
        value = optional(string, "6291456")
      }))
      huge_pages = optional(object({
        value = optional(string, "on")
      }))
      temp_buffers = optional(object({
        value = optional(string, "4000")
      }))
      work_mem = optional(object({
        value = optional(string, "2097151")
      }))
      maintenance_work_mem = optional(object({
        value = optional(string, "512000")
      }))
      autovacuum_work_mem = optional(object({
        value = optional(string, "-1")
      }))
      effective_io_concurrency = optional(object({
        value = optional(string, "32")
      }))
      wal_level = optional(object({
        value = optional(string, "logical")
      }))
      wal_buffers = optional(object({
        value = optional(string, "512")
      }))
      cpu_tuple_cost = optional(object({
        value = optional(string, "0.03")
      }))
      effective_cache_size = optional(object({
        value = optional(string, "350000000")
      }))
      random_page_cost = optional(object({
        value = optional(string, "1.1")
      }))
      checkpoint_timeout = optional(object({
        value = optional(string, "3600")
      }))
      checkpoint_completion_target = optional(object({
        value = optional(string, "0.9")
      }))
      checkpoint_warning = optional(object({
        value = optional(string, "1")
      }))
      log_min_messages = optional(object({
        value = optional(string, "error")
      }))
      log_min_error_statement = optional(object({
        value = optional(string, "error")
      }))
      autovacuum = optional(object({
        value = optional(string, "on")
      }))
      autovacuum_max_workers = optional(object({
        value = optional(string, "10")
      }))
      autovacuum_vacuum_cost_limit = optional(object({
        value = optional(string, "3000")
      }))
      datestyle = optional(object({
        value = optional(string, "ISO, DMY")
      }))
      lc_monetary = optional(object({
        value = optional(string, "en_US.utf-8")
      }))
      lc_numeric = optional(object({
        value = optional(string, "en_US.utf-8")
      }))
      default_text_search_config = optional(object({
        value = optional(string, "pg_catalog.english")
      }))
      max_locks_per_transaction = optional(object({
        value = optional(string, "64")
      }))
      max_wal_senders = optional(object({
        value = optional(string, "5")
      }))
      min_wal_size = optional(object({
        value = optional(string, "8192")
      }))
      max_wal_size = optional(object({
        value = optional(string, "524")
      }))
    }))
    # This parameter is READ-Only in Azure Portal and defaults to ON
    # "synchronous_commit"   = "on",

    # Below set of PostgreSQL are recommended on the Xeon Tunning Guide but are not currently not supported by Azure PostgreSQL flexible server
    # "max_stack_depth"     = 7,
    # "dynamic_shared_memory_type" = "posix",
    # "max_files_per_process" = 4000,
    # "max_pred_locks_per_transaction" = 64,
    # "archive_mode" = "off",
    # "lc_time" = "en_US.UTF-8",
    # "lc_messages" = "en_US.UTF-8",
  })
  default = {
    postgres = {
      autovacuum                   = {}
      autovacuum_max_workers       = {}
      autovacuum_vacuum_cost_limit = {}
      autovacuum_work_mem          = {}
      checkpoint_completion_target = {}
      checkpoint_timeout           = {}
      checkpoint_warning           = {}
      cpu_tuple_cost               = {}
      datestyle                    = {}
      default_text_search_config   = {}
      effective_cache_size         = {}
      effective_io_concurrency     = {}
      huge_pages                   = {}
      lc_monetary                  = {}
      lc_numeric                   = {}
      log_min_error_statement      = {}
      log_min_messages             = {}
      maintenance_work_mem         = {}
      max_connections              = {}
      max_locks_per_transaction    = {}
      max_wal_senders              = {}
      max_wal_size                 = {}
      min_wal_size                 = {}
      random_page_cost             = {}
      shared_buffers               = {}
      temp_buffers                 = {}
      wal_buffers                  = {}
      wal_level                    = {}
      work_mem                     = {}
    }
  }
  description = "Intel Cloud optimizations for Xeon processors"
}

########################
####    Required    ####
########################

variable "resource_group_name" {
  description = "Existing Resource Group where resource will be created."
  type        = string
}

variable "db_password" {
  description = "Password for the master database user."
  type        = string
  sensitive   = true
  validation {
    condition     = length(var.db_password) >= 8
    error_message = "The db_password value must be at least 8 characters in length."
  }
}

variable "db_server_name" {
  description = "Name of the server that will be created."
  type        = string
}

########################
####     Other      ####
########################

variable "db_username" {
  description = "Username for the master database user."
  type        = string
  default     = "pgadmin"
}

variable "db_zone" {
  description = "Specifies the Availability Zone in which this Flexible Server should be located. Possible values are 1, 2 and 3."
  type        = string
  default     = "2"
}

variable "db_ha_standby_zone" {
  description = "Specifies the Availability Zone in which the standby Flexible Server should be located. Possible values are 1, 2 and 3."
  type        = string
  default     = "1"
}

variable "db_ha_mode" {
  description = "The high availability mode for the Flexible Server. Possibles values are ZoneRedundant."
  type        = string
  default     = "ZoneRedundant"
}

variable "db_backup_retention_period" {
  description = "The days to retain backups for. Must be between 1 and 35."
  type        = number
  validation {
    condition     = var.db_backup_retention_period >= 1 && var.db_backup_retention_period <= 35
    error_message = "The db_backup_retention_period must be null or if specified between 7 and 35."
  }
  default = 7
}

variable "db_geo_backup_enabled" {
  description = "Turn Geo-redundant server backups on/off. This allows you to choose between locally redundant or geo-redundant backup storage in the General Purpose and Memory Optimized tiers. When the backups are stored in geo-redundant backup storage, they are not only stored within the region in which your server is hosted, but are also replicated to a paired data center. This provides better protection and ability to restore your server in a different region in the event of a disaster"
  type        = bool
  default     = false
}

variable "db_allocated_storage" {
  description = "The max storage allowed for the PostgreSQL Flexible Server. Possible values (MB) are 32768, 65536, 131072, 262144, 524288, 1048576, 2097152, 4194304, 8388608, and 16777216."
  type        = number
  default     = 2097152
}

variable "db_create_mode" {
  description = "The creation mode which can be used to restore or replicate existing servers."
  type        = string
  validation {
    condition     = contains(["Default", "Replica", "GeoRestore", "PointInTimeRestore"], var.db_create_mode)
    error_message = "The db_create_mode must be \"Default\",\"Replica\",\"GeoRestore\", or \"PointInTimeRestore\"."
  }
  default = "Default"
}

variable "db_create_source_id" {
  description = "For creation modes other than Default, the source server ID to use."
  type        = string
  default     = null
}

variable "db_name" {
  description = "Name of the database that will be created on the flexible instance. If this is specified then a database will be created as a part of the instance provisioning process."
  type        = string
  default     = null
}

variable "db_engine_version" {
  description = "Database engine version for the Azure database instance."
  type        = string
  default     = "14"
}

variable "db_restore_time" {
  description = "When create_mode is PointInTimeRestore, specifies the point in time to restore from creation_source_server_id. It should be provided in RFC3339 format, e.g. 2013-11-08T22:00:40Z."
  type        = string
  default     = null
}

variable "db_collation" {
  description = "Specifies the Collation for the Database."
  type        = string
  default     = "en_US.UTF8"
}

variable "db_charset" {
  description = "Specifies the Charset for the database."
  type        = string
  default     = "UTF8"
}

variable "db_private_dns_zone_id" {
  description = "The ID of the private DNS zone to create the Flexible Server."
  type        = string
  default     = null
}

variable "db_delegated_subnet_id" {
  description = "The ID of the virtual network subnet to create the Flexible Server."
  type        = string
  default     = null
}

variable "db_timeouts" {
  type = object({
    create = optional(string, null)
    delete = optional(string, null)
    update = optional(string, null)
    read   = optional(string, null)
  })
  description = "Map of timeouts that can be adjusted when executing the module. This allows you to customize how long certain operations are allowed to take before being considered to have failed."
  default = {
    db_timeouts = {}
  }
}

variable "db_engine" {
  description = "Database engine for Azure database instance."
  type        = string
  validation {
    condition     = contains(["postgres"], var.db_engine)
    error_message = "The db_engine must be \"postgres\"."
  }
  default = "postgres"
}


variable "tags" {
  description = "Tags to apply to the Database Server"
  type        = map(string)
  default     = {}
}

variable "db_maintenance_day" {
  description = "The day of week for maintenance window."
  type        = string
  default     = null
}

variable "db_maintenance_hour" {
  description = "The start hour for maintenance window."
  type        = string
  default     = null
}

variable "db_maintenance_minute" {
  description = "The start minute for maintenance window."
  type        = string
  default     = null
}

variable "db_firewall_rules" {
  description = "Map of IP ranges that (if specified) will create firewall rules for the server to access those addresses."
  type = list(object({
    name             = string
    start_ip_address = optional(string)
    end_ip_address   = optional(string)
  }))
  default = []
}