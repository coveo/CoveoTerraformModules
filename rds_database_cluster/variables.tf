/**
 * Copyright (c) 2011 - 2019, Coveo Solutions Inc.
 */

// Required variables :

variable "master_password" {
  description = "Password for the master DB user"
}

variable "subnet_ids" {
  type        = "list"
  description = "A list of VPC subnets IDs"
}

// Optional variables :

variable "vpc_id" {
  type = "string"
  description = "VPC ID"
  default = ""
}

variable "instances_count" {
  description = "Number of instances"
  default = 1
}

variable "custom_identifier" {
  description = "An identifier to be used as a default value to identified your ressources."
  default     = ""
}

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

variable "optional_ssm_parameter_tags" {
  type        = "map"
  description = "Additional tags to add to the SSM parameter resources"
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

variable "store_master_creds_to_ssm" {
  default = true
}

variable "store_master_creds_to_secretmanager" {
  default = false
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

variable "iam_roles" {
  type = "list"
  default = []
}

variable "scaling_configuration" {
  type = "list"
  default = []
}

variable "db_parameter_group_name" {
  type = "string"
  default = ""
}

variable "db_cluster_parameter_group_name" {
  type = "string"
  default = ""
}

variable "rds_cluster_db_param_group_params" {
  type = "list"
  default = []
  description = "A list of cluster DB group params."
}

variable "rds_db_param_group_params" {
  type = "list"
  default = []
  description = "A list of DB group params."
}
