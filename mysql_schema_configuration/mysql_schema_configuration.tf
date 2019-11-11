/**
 * Copyright (c) 2011 - 2019, Coveo Solutions Inc.
 */

resource "mysql_database" "schema" {
  name                  = "${var.schema_name}"
  default_character_set = "${lookup(var.optional_parameters, "default_character_set", "utf8")}"
  default_collation     = "${lookup(var.optional_parameters, "default_collation", "utf8_bin")}"
}

resource "mysql_user" "user" {
  user = "${var.username}"

  host               = "%"
  plaintext_password = "${var.password}"
  tls_option         = "${lookup(var.optional_parameters, "tls_option", "NONE")}"
}

resource "mysql_grant" "grants" {
  database = "${mysql_database.schema.name}"

  user       = "${mysql_user.user.user}"
  host       = "${mysql_user.user.host}"
  privileges = "${var.user_privileges}"
  table      = "${lookup(var.optional_parameters, "grants_table", "*")}"
  tls_option = "${lookup(var.optional_parameters, "tls_option", "NONE")}"
}

resource "aws_ssm_parameter" "username" {
  name  = "${var.parameter_store_path}/Username"
  type  = "${lookup(var.optional_parameters, "username_aws_ssm_parameter_type", "String")}"
  value = "${mysql_user.user.user}"

  key_id = "${lookup(var.optional_parameters, "username_kms_key_id", "")}"

  tags = "${var.optional_ssm_parameter_tags}"

  lifecycle {
    ignore_changes = "${lookup(var.optional_parameters, "ssm_parameter_username_ignore_changes", [])}"
  }
}

resource "aws_ssm_parameter" "password" {
  name  = "${var.parameter_store_path}/Password"
  type  = "SecureString"
  value = "${var.password}"

  key_id = "${var.password_kms_key_id}"

  tags = "${var.optional_ssm_parameter_tags}"

  lifecycle {
    ignore_changes = "${lookup(var.optional_parameters, "ssm_parameter_password_ignore_changes", [])}"
  }
}