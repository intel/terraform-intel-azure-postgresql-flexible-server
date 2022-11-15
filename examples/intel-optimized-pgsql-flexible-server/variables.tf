#PostgreSQL Server admin password. Do not commit password to version control systems 
variable "pgsql_administrator_login_password" {
  description = "PostgreSQL server name admin password"
  type        = string
  sensitive   = true
}
