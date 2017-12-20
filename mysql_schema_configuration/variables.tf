/**
 * Copyright (c) 2011 - 2017, Coveo Solutions Inc.
 */

variable "parameter_store_path" {}

variable "schema_name" {}

variable "username" {}

variable "password" {}

variable "password_kms_key_id" {
  default = ""
}

variable "user_privileges" {
  type    = "list"
  default = ["EXECUTE", "SELECT", "SHOW VIEW", "ALTER", "ALTER ROUTINE", "CREATE", "CREATE ROUTINE", "CREATE TEMPORARY TABLES", "CREATE VIEW", "DELETE", "DROP", "INDEX", "INSERT", "TRIGGER", "UPDATE"]
}