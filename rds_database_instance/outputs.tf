/**
 * Copyright (c) 2011 - 2019, Coveo Solutions Inc.
 */

output "endpoint" {
  value = aws_db_instance.rds_db_instance.address
}

output "username" {
  sensitive = true
  value     = aws_db_instance.rds_db_instance.username
}

output "password" {
  sensitive = true
  value     = aws_db_instance.rds_db_instance.password
}

output "port" {
  value = aws_db_instance.rds_db_instance.port
}
