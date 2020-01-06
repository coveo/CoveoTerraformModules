/**
 * Copyright (c) 2011 - 2019, Coveo Solutions Inc.
 */

output "endpoint" {
  value = "${aws_rds_cluster.rds_db_cluster.endpoint}"
}

output "cluster_id" {
  value = "${aws_rds_cluster.rds_db_cluster.id}"
}

output "security_group_id" {
  value = "${element(concat(aws_security_group.rds_cluster_security_group.*.id, list("")), 0)}"
}

output "port" {
  value = "${aws_rds_cluster.rds_db_cluster.port}"
}

output "cluster_arn" {
  value = "${aws_rds_cluster.rds_db_cluster.arn}"
}

output "aws_secretsmanager_secret_id" {
  value = "${element(concat(aws_secretsmanager_secret.master_secret.*.id, list("")), 0)}"
}

output "aws_ssm_path_master_username" {
  value = "${element(concat(aws_ssm_parameter.db_root_master_username.*.name, list("")), 0)}"
}

output "aws_ssm_path_master_password" {
  value = "${element(concat(aws_ssm_parameter.db_root_master_password.*.name, list("")), 0)}"
}
