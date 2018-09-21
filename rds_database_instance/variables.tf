/**
 * Copyright (c) 2011 - 2017, Coveo Solutions Inc.
 */

// Required variables :

variable "password" {
  description = "Password for the master DB user"
}

variable "subnet_ids" {
  type        = "list"
  description = "A list of VPC subnets IDs"
}

// Optional variables :

variable "custom_identifier" {
  description = "An identifier to be used as a default value to identified your ressources."
  default     = ""
}

variable "optional_parameters" {
  type        = "map"
  description = "Parameters with default values. Map key corresponds to rds_db_instance attributes; if no key is present default value is used."
  default     = {}
}

variable "db_tags" {
  type        = "map"
  description = "Tags to attach to the database instance"
  default     = {}
}

variable "availability_zones" {
  type        = "list"
  description = "A list of EC2 Availability Zones that instances in the DB cluster can be created in"
  default     = []
}

variable "vpc_security_group_ids" {
  type        = "list"
  description = "List of VPC security groups to associate with the Cluster"
  default     = []
}

variable "subnet_group_tags" {
  type        = "map"
  description = "A mapping of tags to assign to the resource"
  default     = {}
}

variable "enabled_cloudwatch_logs_exports" {
  type        = "list"
  description = "A list of logs to export to cloudwatch. Possible values are audit, error, general, slowquery"
  default     = []
}