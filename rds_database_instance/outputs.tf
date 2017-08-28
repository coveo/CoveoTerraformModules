/**
 * Copyright (c) 2011 - 2017, Coveo Solutions Inc.
 */

output "endpoint" {
  value = "${aws_db_instance.rds_db_instance.address}"
}

output "port" {
  value = "${aws_db_instance.rds_db_instance.port}"
}
