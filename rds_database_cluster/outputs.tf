/**
 * Copyright (c) 2011 - 2019, Coveo Solutions Inc.
 */

output "endpoint" {
  value = "${aws_rds_cluster.rds_db_cluster.endpoint}"
}

output "username" {
  sensitive = true
  value     = "${aws_ssm_parameter.db_root_master_username.value}"
}

output "password" {
  sensitive = true
  value     = "${aws_ssm_parameter.db_root_master_password.value}"
}

output "port" {
  value = "${aws_rds_cluster.rds_db_cluster.port}"
}

output "cluster_arn" {
  value = "${aws_rds_cluster.rds_db_cluster.arn}"
}
