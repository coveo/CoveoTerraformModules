/**
 * Copyright (c) 2011 - 2019, Coveo Solutions Inc.
 */

resource "aws_db_subnet_group" "db_subnet_group" {
  subnet_ids = "${var.subnet_ids}"

  name        = "${lookup(var.optional_parameters, "db_subnet_group_name", "${var.custom_identifier}")}"
  description = "${lookup(var.optional_parameters, "subnet_group_description", "${var.custom_identifier}")}"
  tags        = "${var.subnet_group_tags}"
}

resource "aws_ssm_parameter" "db_root_master_username" {
  name  = "${lookup(var.optional_parameters, "parameter_store_path", "${var.custom_identifier}")}/${lookup(var.optional_parameters, "parameter_store_username_key", "Username")}"
  type  = "String"
  value = "${lookup(var.optional_parameters, "master_username", "root")}"
  tags  = "${var.optional_ssm_parameter_tags}"

  lifecycle {
    ignore_changes = ["value"]
  }
}

resource "aws_ssm_parameter" "db_root_master_password" {
  name  = "${lookup(var.optional_parameters, "parameter_store_path", "${var.custom_identifier}")}/${lookup(var.optional_parameters, "parameter_store_password_key", "Password")}"
  type  = "SecureString"
  value = "${var.master_password}"

  key_id = "${lookup(var.optional_parameters, "master_password_kms_key_id", "")}"
  tags   = "${var.optional_ssm_parameter_tags}"

  lifecycle {
    ignore_changes = ["value"]
  }
}

resource "aws_rds_cluster" "rds_db_cluster" {
  // Note: username length must be between 2 and 16 character or AWS return an error
  master_username = "${aws_ssm_parameter.db_root_master_username.value}"
  master_password = "${aws_ssm_parameter.db_root_master_password.value}"

  cluster_identifier                  = "${lookup(var.optional_parameters, "cluster_identifier", "${var.custom_identifier}-cluster")}"
  global_cluster_identifier           = "${lookup(var.optional_parameters, "global_cluster_identifier", "")}"
  engine                              = "${lookup(var.optional_parameters, "engine", "aurora")}"
  engine_mode                         = "${lookup(var.optional_parameters, "engine_mode", "provisioned")}"
  engine_version                      = "${lookup(var.optional_parameters, "engine_version", "aurora5.6")}"
  database_name                       = "${lookup(var.optional_parameters, "database_name", "")}"
  skip_final_snapshot                 = "${lookup(var.optional_parameters, "skip_final_snapshot", true)}"
  availability_zones                  = ["${var.availability_zones}"]
  backup_retention_period             = "${lookup(var.optional_parameters, "backup_retention_period", 14)}"
  preferred_backup_window             = "${lookup(var.optional_parameters, "preferred_backup_window", "")}"
  preferred_maintenance_window        = "${lookup(var.optional_parameters, "preferred_maintenance_window", "")}"
  port                                = "${lookup(var.optional_parameters, "port", 3306)}"
  vpc_security_group_ids              = ["${var.vpc_security_group_ids}"]
  snapshot_identifier                 = "${lookup(var.optional_parameters, "snapshot_identifier", "")}"
  final_snapshot_identifier           = "${var.final_snapshot_identifier}"
  storage_encrypted                   = "${lookup(var.optional_parameters, "storage_encrypted", true)}"
  apply_immediately                   = "${lookup(var.optional_parameters, "apply_immediately", false)}"
  db_subnet_group_name                = "${aws_db_subnet_group.db_subnet_group.name}"
  db_cluster_parameter_group_name     = "${lookup(var.optional_parameters, "db_cluster_parameter_group_name", "")}"
  kms_key_id                          = "${lookup(var.optional_parameters, "kms_key_id", "")}"
  iam_database_authentication_enabled = "${lookup(var.optional_parameters, "iam_database_authentication_enabled", false)}"
  enabled_cloudwatch_logs_exports     = ["${var.enabled_cloudwatch_logs_exports}"]
  deletion_protection                 = "${lookup(var.optional_parameters, "deletion_protection", false)}"

  tags = "${var.db_tags}"

  lifecycle {
    ignore_changes = ["master_password"]
  }
}

resource "aws_rds_cluster_instance" "rds_db_cluster_instance" {
  cluster_identifier = "${aws_rds_cluster.rds_db_cluster.id}"

  count                        = "${var.instances_count}"
  identifier                   = "${lookup(var.optional_parameters, "cluster_instance_identifier", "${var.custom_identifier}")}-${count.index}"
  engine                       = "${lookup(var.optional_parameters, "engine", "aurora")}"
  engine_version               = "${lookup(var.optional_parameters, "engine_version", "aurora5.6")}"
  instance_class               = "${lookup(var.optional_parameters, "instance_class", "db.r3.large")}"
  publicly_accessible          = "${lookup(var.optional_parameters, "publicly_accessible", false)}"
  db_subnet_group_name         = "${aws_db_subnet_group.db_subnet_group.name}"
  db_parameter_group_name      = "${lookup(var.optional_parameters, "db_parameter_group_name", "")}"
  apply_immediately            = "${lookup(var.optional_parameters, "apply_immediately", false)}"
  monitoring_role_arn          = "${lookup(var.optional_parameters, "monitoring_role_arn", "")}"
  monitoring_interval          = "${lookup(var.optional_parameters, "monitoring_interval", 0)}"
  promotion_tier               = "${lookup(var.optional_parameters, "promotion_tier", 0)}"
  auto_minor_version_upgrade   = "${lookup(var.optional_parameters, "auto_minor_version_upgrade", true)}"
  performance_insights_enabled = "${lookup(var.optional_parameters, "performance_insights_enabled", false)}"
  copy_tags_to_snapshot        = "${lookup(var.optional_parameters, "copy_tags_to_snapshot", true)}"

  tags = "${var.db_tags}"
}
