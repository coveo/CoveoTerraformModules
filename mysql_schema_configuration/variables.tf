/**
 * Copyright (c) 2011 - 2019, Coveo Solutions Inc.
 */

variable "parameter_store_path" {}

variable "schema_name" {}

variable "optional_parameters" {
  type        = "map"
  description = "Parameters with default values. Possible keys are username_aws_ssm_parameter_type and username_kms_key_id; if no key is present default value is used."
  default     = {}
}

variable "optional_ssm_parameter_tags" {
  type        = "map"
  description = "Additional tags to add to the SSM parameter resources"
  default     = {}
}

variable "user_privileges" {
  type    = "list"
  default = ["EXECUTE", "SELECT", "SHOW VIEW", "ALTER", "ALTER ROUTINE", "CREATE", "CREATE ROUTINE",
    "CREATE TEMPORARY TABLES", "CREATE VIEW", "DELETE", "DROP", "INDEX", "INSERT", "TRIGGER", "UPDATE"]
}
