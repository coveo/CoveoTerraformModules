/**
 * Copyright (c) 2011 - 2019, Coveo Solutions Inc.
 */

resource "mysql_database" "schema" {
  name                  = var.schema_name
  default_character_set = lookup(var.optional_parameters, "default_character_set", "utf8")
  default_collation     = lookup(var.optional_parameters, "default_collation", "utf8_bin")
}

resource "aws_ssm_parameter" "username" {
  name  = "${var.parameter_store_path}/Username"
  type  = lookup(var.optional_parameters, "username_aws_ssm_parameter_type", "String")
  value = "PLACEHOLDER"

  key_id = lookup(var.optional_parameters, "username_kms_key_id", "")

  tags = var.optional_ssm_parameter_tags

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "password" {
  name  = "${var.parameter_store_path}/Password"
  type  = "SecureString"
  value = "PLACEHOLDER"

  key_id = var.password_kms_key_id

  tags = var.optional_ssm_parameter_tags

  lifecycle {
    ignore_changes = [value]
  }
}