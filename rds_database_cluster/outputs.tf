/**
 * Copyright (c) 2011 - 2017, Coveo Solutions Inc.
 */

output "endpoint" {
  value = "${aws_rds_cluster.rds_db_cluster.endpoint}"
}

output "port" {
  value = "${aws_rds_cluster.rds_db_cluster.port}"
}
