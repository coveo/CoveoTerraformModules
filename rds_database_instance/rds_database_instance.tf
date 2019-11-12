/**
 * Copyright (c) 2011 - 2019, Coveo Solutions Inc.
 */

resource "aws_db_subnet_group" "db_subnet_group" {
  subnet_ids = "${var.subnet_ids}"

  name        = "${lookup(var.optional_parameters, "db_subnet_group_name", "${var.custom_identifier}")}"
  description = "${lookup(var.optional_parameters, "subnet_group_description", "${var.custom_identifier}")}"
  tags        = "${var.subnet_group_tags}"
}

resource "aws_ssm_parameter" "db_root_username" {
  name  = "${lookup(var.optional_parameters, "parameter_store_path", "${var.custom_identifier}")}/${lookup(var.optional_parameters, "parameter_store_username_key", "Username")}"
  type  = "String"
  value = "${lookup(var.optional_parameters, "username", "root_db")}"
  tags  = "${var.optional_ssm_parameter_tags}"

  lifecycle {
    ignore_changes = ["value"]
  }
}

resource "aws_ssm_parameter" "db_root_password" {
  name  = "${lookup(var.optional_parameters, "parameter_store_path", "${var.custom_identifier}")}/${lookup(var.optional_parameters, "parameter_store_password_key", "Password")}"
  type  = "SecureString"
  value = "${var.password}"

  key_id = "${lookup(var.optional_parameters, "password_kms_key_id", "")}"
  tags   = "${var.optional_ssm_parameter_tags}"

  lifecycle {
    ignore_changes = ["value"]
  }
}

resource "aws_db_instance" "rds_db_instance" {
  // Note: username length must be between 2 and 16 character or AWS return an error
  username = "${aws_ssm_parameter.db_root_username.value}"
  password = "${aws_ssm_parameter.db_root_password.value}"

  identifier                          = "${lookup(var.optional_parameters, "identifier", "${var.custom_identifier}")}"
  allocated_storage                   = "${lookup(var.optional_parameters, "allocated_storage", 100)}"
  engine                              = "${lookup(var.optional_parameters, "engine", "aurora")}"
  engine_version                      = "${lookup(var.optional_parameters, "engine_version", "5.6.10a")}"
  instance_class                      = "${lookup(var.optional_parameters, "instance_class", "db.r3.large")}"
  storage_type                        = "${lookup(var.optional_parameters, "storage_type", "aurora")}"
  skip_final_snapshot                 = "${lookup(var.optional_parameters, "skip_final_snapshot", true)}"
  copy_tags_to_snapshot               = "${lookup(var.optional_parameters, "copy_tags_to_snapshot", true)}"
  name                                = "${lookup(var.optional_parameters, "database_name", "")}"
  multi_az                            = "${lookup(var.optional_parameters, "multi_az", false)}"
  backup_retention_period             = "${lookup(var.optional_parameters, "backup_retention_period", 14)}"
  backup_window                       = "${lookup(var.optional_parameters, "backup_window", "")}"
  maintenance_window                  = "${lookup(var.optional_parameters, "maintenance_window", "")}"
  port                                = "${lookup(var.optional_parameters, "port", 3306)}"
  publicly_accessible                 = "${lookup(var.optional_parameters, "publicly_accessible", false)}"
  vpc_security_group_ids              = ["${var.vpc_security_group_ids}"]
  db_subnet_group_name                = "${aws_db_subnet_group.db_subnet_group.name}"
  parameter_group_name                = "${lookup(var.optional_parameters, "db_parameter_group_name", "")}"
  option_group_name                   = "${lookup(var.optional_parameters, "option_group_name", "")}"
  storage_encrypted                   = "${lookup(var.optional_parameters, "storage_encrypted", true)}"
  apply_immediately                   = "${lookup(var.optional_parameters, "apply_immediately", false)}"
  snapshot_identifier                 = "${lookup(var.optional_parameters, "snapshot_identifier", "")}"
  final_snapshot_identifier           = "${var.final_snapshot_identifier}"
  license_model                       = "${lookup(var.optional_parameters, "license_model", "")}"
  auto_minor_version_upgrade          = "${lookup(var.optional_parameters, "auto_minor_version_upgrade", true)}"
  allow_major_version_upgrade         = "${lookup(var.optional_parameters, "allow_major_version_upgrade", false)}"
  monitoring_role_arn                 = "${lookup(var.optional_parameters, "monitoring_role_arn", "")}"
  monitoring_interval                 = "${lookup(var.optional_parameters, "monitoring_interval", 0)}"
  kms_key_id                          = "${lookup(var.optional_parameters, "kms_key_id", "")}"
  iam_database_authentication_enabled = "${lookup(var.optional_parameters, "iam_database_authentication_enabled", false)}"
  tags                                = "${var.db_tags}"
  enabled_cloudwatch_logs_exports     = ["${var.enabled_cloudwatch_logs_exports}"]
  deletion_protection                 = "${lookup(var.optional_parameters, "deletion_protection", false)}"

  lifecycle {
    ignore_changes = ["password"]
  }
}
