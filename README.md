# Coveo Terraform modules

A collection of Terraform modules.

Table of content:

* [Description](#description)
* [Usage](#usage)

## Description

This repository is a selection of Terraform modules we used at Coveo. We now support the following modules :

### mysql_schema_configuration

This module is now deprecated. It is only available for backward compatibility.

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
locals "optional_parameters" {
  backup_retention_period         = "YOUR RETENTION PERIOD"
  db_subnet_group_name            = "YOUR DB SUBNET GROUP NAME"
  db_cluster_parameter_group_name = "YOUR CLUSTER PARAMETER GROUP NAME"
  db_parameter_group_name         = "YOUR PARAMETER GROUP NAME"
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

  db_tags = {
    "YOUR DB TAGS"
  }
}
```
