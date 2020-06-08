/**
 * Copyright (c) 2011 - 2019, Coveo Solutions Inc.
 */

output "endpoint" {
  value = "${aws_rds_cluster.rds_db_cluster.endpoint}"
}

output "username" {
  value     = "${aws_rds_cluster.rds_db_cluster.master_username}"
}

output "password" {
  value     = "${aws_rds_cluster.rds_db_cluster.master_password}"
}

output "port" {
  value = "${aws_rds_cluster.rds_db_cluster.port}"
}

output "cluster_arn" {
  value = "${aws_rds_cluster.rds_db_cluster.arn}"
}
