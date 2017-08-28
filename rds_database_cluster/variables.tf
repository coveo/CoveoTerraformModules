/**
 * Copyright (c) 2011 - 2017, Coveo Solutions Inc.
 */

// Required variables :

variable "master_username" {
  description = "Username for the master DB user"
}

variable "master_password" {
  description = "Password for the master DB user"
}

variable "cluster_identifier" {
  description = "The cluster identifier"
}

// Optional variables :

variable "optional_parameters" {
  type        = "map"
  description = "Parameters with default values. Map key corresponds to rds_db_cluster and rds_db_cluster_instance attributes; if no key is present default value is used."
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
