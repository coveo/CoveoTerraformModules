/**
 * Copyright (c) 2011 - 2017, Coveo Solutions Inc.
 */

resource "aws_db_subnet_group" "db_subnet_group" {
  subnet_ids = "${var.subnet_ids}"

  name        = "${lookup(var.optional_parameters, "db_subnet_group_name", "${var.custom_identifier}")}"
  description = "${lookup(var.optional_parameters, "subnet_group_description", "")}"                     // TODO : Not sure if we should put the custom_identifier or roll with terraform default?
  tags        = "${var.subnet_group_tags}"
}

resource "aws_ssm_parameter" "db_root_master_username" {
  name  = "${lookup(var.optional_parameters, "parameter_store_path", "${var.custom_identifier}")}/Username"
  type  = "SecureString"
  value = "${lookup(var.optional_parameters, "master_username", "root")}"

  key_id = "${lookup(var.optional_parameters, "master_username_kms_key_id", "")}"
}

resource "aws_ssm_parameter" "db_root_master_password" {
  name  = "${lookup(var.optional_parameters, "parameter_store_path", "${var.custom_identifier}")}/Password"
  type  = "SecureString"
  value = "${var.master_password}"

  key_id = "${lookup(var.optional_parameters, "master_password_kms_key_id", "")}"
}

resource "aws_rds_cluster" "rds_db_cluster" {
  // Note: username length must be between 2 and 16 character or AWS return an error
  master_username = "${aws_ssm_parameter.db_root_master_username.value}"
  master_password = "${aws_ssm_parameter.db_root_master_password.value}"

  cluster_identifier                  = "${lookup(var.optional_parameters, "cluster_identifier", "${var.custom_identifier}-cluster")}"
  database_name                       = "${lookup(var.optional_parameters, "database_name", "")}"
  skip_final_snapshot                 = "${lookup(var.optional_parameters, "skip_final_snapshot", true)}"
  availability_zones                  = ["${var.availability_zones}"]
  backup_retention_period             = "${lookup(var.optional_parameters, "backup_retention_period", 1)}"
  preferred_backup_window             = "${lookup(var.optional_parameters, "preferred_backup_window", "")}"
  preferred_maintenance_window        = "${lookup(var.optional_parameters, "preferred_maintenance_window", "")}"
  port                                = "${lookup(var.optional_parameters, "port", 3306)}"
  vpc_security_group_ids              = ["${var.vpc_security_group_ids}"]
  snapshot_identifier                 = "${lookup(var.optional_parameters, "snapshot_identifier", "")}"
  storage_encrypted                   = "${lookup(var.optional_parameters, "storage_encrypted", false)}"
  apply_immediately                   = "${lookup(var.optional_parameters, "apply_immediately", false)}"
  db_subnet_group_name                = "${aws_db_subnet_group.db_subnet_group.name}"
  db_cluster_parameter_group_name     = "${lookup(var.optional_parameters, "db_cluster_parameter_group_name", "")}"
  kms_key_id                          = "${lookup(var.optional_parameters, "kms_key_id", "")}"
  iam_database_authentication_enabled = "${lookup(var.optional_parameters, "iam_database_authentication_enabled", false)}"
}

resource "aws_rds_cluster_instance" "rds_db_cluster_instance" {
  cluster_identifier = "${aws_rds_cluster.rds_db_cluster.id}"

  count                      = "${lookup(var.optional_parameters, "count", 1)}"
  identifier                 = "${lookup(var.optional_parameters, "cluster_instance_identifier", "${var.custom_identifier}")}-${count.index}"
  instance_class             = "${lookup(var.optional_parameters, "instance_class", "db.r3.large")}"
  publicly_accessible        = "${lookup(var.optional_parameters, "publicly_accessible", false)}"
  db_subnet_group_name       = "${aws_db_subnet_group.db_subnet_group.name}"
  db_parameter_group_name    = "${lookup(var.optional_parameters, "db_parameter_group_name", "")}"
  apply_immediately          = "${lookup(var.optional_parameters, "apply_immediately", false)}"
  monitoring_role_arn        = "${lookup(var.optional_parameters, "monitoring_role_arn", "")}"
  monitoring_interval        = "${lookup(var.optional_parameters, "monitoring_interval", 0)}"
  promotion_tier             = "${lookup(var.optional_parameters, "promotion_tier", 0)}"
  auto_minor_version_upgrade = "${lookup(var.optional_parameters, "auto_minor_version_upgrade", true)}"

  tags = "${var.db_tags}"
}
