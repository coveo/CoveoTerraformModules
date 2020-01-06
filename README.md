# Coveo Terraform modules

A collection of Terraform modules.

Table of content:

* [Description](#description)
* [Usage](#usage)

## Description

This repository is a selection of Terraform modules we used at Coveo. We now support the following modules :

### rds_database_cluster

This module creates a [RDS Cluster Resource](https://www.terraform.io/docs/providers/aws/r/rds_cluster.html), his [RDS Cluster Resource Instance](https://www.terraform.io/docs/providers/aws/r/rds_cluster_instance.html) and a [RDS DB subnet group ressource](https://www.terraform.io/docs/providers/aws/r/db_subnet_group.html). It also store the database username and password into the parameter store by creating two [SSM Parameter resource](https://www.terraform.io/docs/providers/aws/r/ssm_parameter.html). You have to provide it with minimally a list of subnet_ids, the database master password and a custom_identifier. This module outputs the cluster endpoint which is the DNS address of the RDS instance, the master username, the master password and the port used by the database.

### rds_database_instance

This module creates a [RDS Instance Resource](https://www.terraform.io/docs/providers/aws/r/db_instance.html) with a [RDS DB subnet group ressource](https://www.terraform.io/docs/providers/aws/r/db_subnet_group.html). It also store the database username and password into the parameter store by creating two [SSM Parameter resource](https://www.terraform.io/docs/providers/aws/r/ssm_parameter.html). You have to provide it with minimally a list of subnet_ids, the master password and a custom_identifier. This module outputs the connection endpoint, the master username, the master password and the port used by the database.

### coveo-eks

This module deploy an EKS cluster with all requirements embedded. It include :

* Kiam
* ExternalDNS
* ClusterAutoscaler
* Iam Authenticator operator
* Filebeat
* Thanos

## Usage

You can simply import the module you want to use in your terraform infrastructure directly from our github. We recommend using a tag to specify the version of the module you want to use. It will ensure your infrastructure won't stop working when a module is updated. The following example is how you would import the version 0.7 of the rds_database_cluster module in your terraform file.

```bash
source = "git::https://github.com/coveo/CoveoTerraformModules.git//rds_database_cluster?ref=v0.7"
```

Here is a more complete example using the optional parameters map :

```bash
# https://aws.amazon.com/blogs/database/best-practices-for-configuring-parameters-for-amazon-rds-for-mysql-part-3-parameters-related-to-security-operational-manageability-and-connectivity-timeout/
# Use utf8mb4 where possible. utf-8 is not really utf-8. https://medium.com/@adamhooper/in-mysql-never-use-utf8-use-utf8mb4-11761243e434
locals "rds_param_group_params" [
    {
      name         = "binlog_format"
      value        = "ROW"
      apply_method = "pending-reboot"
    },
    {
      name  = "collation_server"
      value = "utf8_general_ci"
    },
    {
      name  = "collation_connection"
      value = "utf8_general_ci"
    },
    {
      name  = "character_set_client"
      value = "utf8mb4"
    },
    {
      name  = "character_set_connection"
      value = "utf8mb4"
    },
    {
      name  = "character_set_database"
      value = "utf8mb4"
    },
    {
      name  = "character_set_results"
      value = "utf8mb4"
    },
    {
      name  = "character_set_filesystem"
      value = "binary"
    },
    {
      name  = "character_set_server"
      value = "utf8mb4"
    }
]

locals "rds_db_group_param" [
    {
      name  = "name"
      value = "rds-pg"
    },
    {
      name  = "family"
      value = "mysql5.6"
    },
    {
      name  = "name"
      value = "rds-pg"
    },
    {
      name  = "character_set_server"
      value = "utf8mb4"
    },
    {
      name  = "character_set_client"
      value = "utf8mb4"
    }
]

resource "random_string" "final_snapshot_identifier" {
  length = 16
  special = false
}

locals "optional_parameters" {
  # https://www.terraform.io/docs/providers/aws/r/rds_cluster.html#engine_mode
  # global, multimaster, parallelquery, provisioned, serverless.
  # Default: provisioned 
  engine_mode                     = "provisioned"
  
   # https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/AuroraMySQL.Updates.html
  # https://www.terraform.io/docs/providers/aws/r/rds_cluster.html#engine
  # Engine aurora refers to Aurora MySQL 1.x and aurora-mysql refers to 2.x
  # Default: aurora
  engine                          = "aurora"
  
  # To use Aurora 1.x set 5.6.10a or higher 
  # To use Aurora 2.x set the MySQL version to 5.7.12 or higher
  # Default: 5.6.10a
  engine_version                  = "5.6.10a"
  
  # Use System Manager SSM Parameter store to store creds
  # Default: true
  store_master_creds_to_ssm       = true
  
  # Use Secret Manager to store creds
  # Default: false
  store_master_creds_to_secretmanager  = true

  # New params for in-module parameter groups  
  # Cluster parameter group name
  rds_cluster_param_group_name = "something-somehting-cluster"
  # DB parameter group name
  rds_db_param_group_name       = "something-somehting-db"
  
  # Cluster parameter group family
  # Run aws rds describe-db-engine-versions --query "DBEngineVersions[].DBParameterGroupFamily" to get a list of family or go see the list on the UI console
  # Default value: aurora5.6
  rds_cluster_db_group_family = "aurora5.6"

  # DB parameter group family
  # Same as rds_cluster_db_group_family, run aws command above
  # Default value: aurora5.6
  rds_db_group_family = "aurora5.6"
  
  # Optional final snapshot id
  final_snapshot_identifier       = "something-something-${random_string.final_snapshot_identifier.result}"
  
  backup_retention_period         = "YOUR RETENTION PERIOD"
  db_subnet_group_name            = "YOUR DB SUBNET GROUP NAME"
  db_cluster_parameter_group_name = "YOUR CLUSTER PARAMETER GROUP NAME"
  db_parameter_group_name         = "YOUR PARAMETER GROUP NAME"
  
  # Optional if you provide vpc_security_group_ids
  vpc_id                          = "YOUR VPC ID"
}

module "rds_database_cluster" {
  source = "git::https://github.com/coveo/CoveoTerraformModules.git//rds_database_cluster?ref=v0.7"

  master_password        = "YOUR MASTER PASSWORD"
  subnet_ids             = ["YOUR SUBNET IDS"]
  custom_identifier      = ["A CUSTOM IDENTIFIER"]
  vpc_security_group_ids = ["A VPC SECURITY GROUP ID"]
  availability_zones     = ["AN AVAILABILITY ZONE", "ANOTHER AVAILABILITY ZONE"]
  optional_parameters    = "${locals.optional_parameters}"
  
  # Those options have been moved from optional_parameters to module variables. The reason is the generalized "Value of count cannot be computed" issue. Because of that params in optional_parameters cannot be used to compute a count of a resource.
  db_cluster_parameter_group_name = "something-somehting-cluster"
  db_parameter_group_name = "something-somehting-db"

  db_tags = {
    "YOUR DB TAGS"
  }
}
```
