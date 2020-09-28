/**
 * Copyright (c) 2011 - 2019, Coveo Solutions Inc.
 */

output "endpoint" {
  value = aws_rds_cluster.rds_db_cluster.endpoint
}

output "username" {
  sensitive = true
  value     = aws_rds_cluster.rds_db_cluster.master_username
}

output "password" {
  sensitive = true
  value     = aws_rds_cluster.rds_db_cluster.master_password
}

output "port" {
  value = aws_rds_cluster.rds_db_cluster.port
}
