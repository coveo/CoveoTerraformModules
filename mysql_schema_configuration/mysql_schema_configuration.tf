/**
 * Copyright (c) 2011 - 2019, Coveo Solutions Inc.
 */

locals {
  user_value = "${var.username}"
  host       = "%"
}

resource "mysql_database" "schema" {
  name              = "${var.schema_name}"
  default_collation = "utf8_bin"
}

resource "mysql_user" "user" {
  user = "${local.user_value}"

  host               = "${local.host}"
  plaintext_password = "${var.password}"
  count              = "${var.use_tls_option == 0 ? 1 : 0}"
}

resource "mysql_user" "user_with_tls_option" {
  user = "${local.user_value}"

  host               = "${local.host}"
  plaintext_password = "${var.password}"
  tls_option         = "${lookup(var.optional_parameters, "tls_option", "")}"

  count = "${var.use_tls_option == 1 ? 1 : 0}"
}

resource "mysql_grant" "grants" {
  database = "${mysql_database.schema.name}"

  user       = "${local.user_value}"
  host       = "${local.host}"
  privileges = "${var.user_privileges}"
  table      = "${lookup(var.optional_parameters, "grants_table", "*")}"

  count      = "${var.use_tls_option == 0 ? 1 : 0}"
}

resource "mysql_grant" "grants_with_tls_option" {
  database = "${mysql_database.schema.name}"
  
  user       = "${local.user_value}"
  host       = "${local.host}"
  privileges = "${var.user_privileges}"
  table      = "${lookup(var.optional_parameters, "grants_table", "*")}"
  tls_option = "${lookup(var.optional_parameters, "tls_option", "")}"

  count = "${var.use_tls_option == 1 ? 1 : 0}"
}

resource "aws_ssm_parameter" "username" {
  name  = "${var.parameter_store_path}/Username"
  type  = "${lookup(var.optional_parameters, "username_aws_ssm_parameter_type", "String")}"
  value = "${local.user_value}"

  key_id = "${lookup(var.optional_parameters, "username_kms_key_id", "")}"
}

resource "aws_ssm_parameter" "password" {
  name  = "${var.parameter_store_path}/Password"
  type  = "SecureString"
  value = "${var.password}"

  key_id = "${var.password_kms_key_id}"
}
