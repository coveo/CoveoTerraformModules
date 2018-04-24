/**
 * Copyright (c) 2011 - 2017, Coveo Solutions Inc.
 */

output "user" {
  value = "${mysql_user.user.user}"
}

output "host" {
  value = "${mysql_user.user.host}"
}

output "schema_name" {
  value = "${mysql_database.schema.name}"
}

output "user_param_name" {
  value = "${aws_ssm_parameter.username.name}"
}

output "password_param_name" {
  value = "${aws_ssm_parameter.password.name}"
}
