/**
 * Copyright (c) 2011 - 2017, Coveo Solutions Inc.
 */

resource "mysql_database" "schema" {
  name              = "${var.schema_name}"
  default_collation = "utf8_bin"
}

resource "mysql_user" "user" {
  user               = "${var.username}"
  host               = "%"
  plaintext_password = "${var.password}"
}

resource "mysql_grant" "grants" {
  user       = "${mysql_user.user.user}"
  host       = "${mysql_user.user.host}"
  database   = "${mysql_database.schema.name}"
  privileges = "${var.user_privileges}"
}

resource "aws_ssm_parameter" "username" {
  name  = "${var.parameter_store_path}/Username"
  type  = "${lookup(var.optional_parameters, "username_aws_ssm_parameter_type", "String")}"
  value = "${mysql_user.user.user}"

  key_id = "${lookup(var.optional_parameters, "username_kms_key_id", "")}"
}

resource "aws_ssm_parameter" "password" {
  name  = "${var.parameter_store_path}/Password"
  type  = "SecureString"
  value = "${var.password}"

  key_id = "${var.password_kms_key_id}"
}
