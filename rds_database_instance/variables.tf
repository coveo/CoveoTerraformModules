/**
 * Copyright (c) 2011 - 2019, Coveo Solutions Inc.
 */

// Required variables :

variable "password" {
  description = "Password for the master DB user"
}

variable "subnet_ids" {
  type        = list(string)
  description = "A list of VPC subnets IDs"
}

variable "final_snapshot_identifier" {
  type        = string
  description = "Creates a snapshot with this identifier when the DB cluster is deleted"
}

// Optional variables :

variable "custom_identifier" {
  description = "An identifier to be used as a default value to identified your ressources."
  default     = ""
}

variable "optional_parameters" {
  type        = map(string)
  description = "Parameters with default values. Map key corresponds to rds_db_instance attributes; if no key is present default value is used."
  default     = {}
}

variable "db_tags" {
  type        = map(string)
  description = "Tags to attach to the database instance"
  default     = {}
}

variable "optional_ssm_parameter_tags" {
  type        = map(string)
  description = "Additional tags to add to the SSM parameter resources"
  default     = {}
}

variable "availability_zones" {
  type        = list(string)
  description = "A list of EC2 Availability Zones that instances in the DB cluster can be created in"
  default     = []
}

variable "vpc_security_group_ids" {
  type        = list(string)
  description = "List of VPC security groups to associate with the Cluster"
  default     = []
}

variable "subnet_group_tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the resource"
  default     = {}
}

variable "enabled_cloudwatch_logs_exports" {
  type        = list(string)
  description = "A list of logs to export to cloudwatch. Possible values are audit, error, general, slowquery"
  default     = []
}