/**
 * Copyright (c) 2011 - 2019, Coveo Solutions Inc.
 */

output "schema_name" {
  value = "${mysql_database.schema.name}"
}

output "username_ssm_key" {
  value = "${aws_ssm_parameter.username.name}"
}

output "password_ssm_key" {
  value = "${aws_ssm_parameter.password.name}"
}
