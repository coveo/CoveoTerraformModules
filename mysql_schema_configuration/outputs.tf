/**
 * Copyright (c) 2011 - 2019, Coveo Solutions Inc.
 */

output "user" {
  value = "${local.user_value}"
}

output "host" {
  value = "${local.host}"
}

output "schema_name" {
  value = "${mysql_database.schema.name}"
}

output "username_ssm_key" {
  value = "${aws_ssm_parameter.username.name}"
}

output "password_ssm_key" {
  value = "${aws_ssm_parameter.password.name}"
}
