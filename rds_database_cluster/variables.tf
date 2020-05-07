/**
 * Copyright (c) 2011 - 2017, Coveo Solutions Inc.
 */

// Required variables :

variable "master_password" {
  description = "Password for the master DB user"
}

variable "subnet_ids" {
  type        = list(string)
  description = "A list of VPC subnets IDs"
}

// Optional variables :

variable "instances_count" {
  description = "Number of instances"
  default     = 1
}

variable "custom_identifier" {
  description = "An identifier to be used as a default value to identified your ressources."
  default     = ""
}

variable "optional_parameters" {
  type        = map(string)
  description = "Parameters with default values. Map key corresponds to rds_db_cluster and rds_db_cluster_instance attributes; if no key is present default value is used."
  default     = {}
}

variable "db_tags" {
  type        = map(string)
  description = "Tags to attach to the database instance"
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

