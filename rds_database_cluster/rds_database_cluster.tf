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
  count = "${var.store_master_creds_to_ssm ? 1 : 0}"
  name  = "${lookup(var.optional_parameters, "parameter_store_path", "${var.custom_identifier}")}/${lookup(var.optional_parameters, "parameter_store_username_key", "Username")}"
  type  = "String"
  value = "${local.master_username}"
  tags  = "${var.optional_ssm_parameter_tags}"

  lifecycle {
    ignore_changes = ["value"]
  }
}

resource "aws_ssm_parameter" "db_root_master_password" {
  count = "${var.store_master_creds_to_ssm ? 1 : 0}"
  name  = "${lookup(var.optional_parameters, "parameter_store_path", "${var.custom_identifier}")}/${lookup(var.optional_parameters, "parameter_store_password_key", "Password")}"
  type  = "SecureString"
  value = "${var.master_password}"

  key_id = "${lookup(var.optional_parameters, "master_password_kms_key_id", "")}"
  tags   = "${var.optional_ssm_parameter_tags}"

  lifecycle {
    ignore_changes = ["value"]
  }
}

resource "aws_secretsmanager_secret" "master_secret" {
  count = "${var.store_master_creds_to_secretmanager ? 1 : 0}"
  name                = "${lookup(var.optional_parameters, "secret_manager_rotation_name_master", "")}"
  rotation_lambda_arn = "${lookup(var.optional_parameters, "secret_manager_rotation_lambda_arn_master", "")}"

  kms_key_id = "${lookup(var.optional_parameters, "secret_kms_key_id", "")}"
  policy = "${lookup(var.optional_parameters, "secret_policy", "")}"
  recovery_window_in_days = "${lookup(var.optional_parameters, "secret_recovery_window_in_days", 7)}"

  rotation_rules {
    automatically_after_days = "${lookup(var.optional_parameters, "secret_automatically_after_days", 7)}"
  }
  depends_on = ["aws_rds_cluster.rds_db_cluster"]
}

resource "aws_secretsmanager_secret_version" "master_secret_value" {
  count = "${var.store_master_creds_to_secretmanager ? 1 : 0}"
  secret_id     = "${element(concat(aws_secretsmanager_secret.master_secret.*.id, list("")), 0)}"
  secret_string = "${jsonencode(local.master_secret_value_map)}"
  depends_on = ["aws_secretsmanager_secret.master_secret"]
}

resource "aws_security_group" "rds_cluster_security_group" {
  count = "${length(var.vpc_id) > 0 ? 1 : 0}"
  name   = "${lookup(var.optional_parameters, "rds_cluster_sg_group_name", "${var.custom_identifier}")}"
  vpc_id = "${var.vpc_id}"
  tags   = "${var.db_tags}"
}

resource "aws_db_parameter_group" "rds_cluster_db_param_group" {
  count     = "${var.db_parameter_group_name == "" ? 1 : 0}"
  name      = "${lookup(var.optional_parameters, "rds_db_param_group_name", "${var.custom_identifier}")}"
  family    = "${lookup(var.optional_parameters, "rds_db_group_family", "aurora5.6")}"
  parameter = ["${var.rds_db_param_group_params}"]
  tags      = "${var.db_tags}"
}

resource "aws_rds_cluster_parameter_group" "rds_cluster_param_group" {
  count     = "${var.db_cluster_parameter_group_name == "" ? 1 : 0}"
  name      = "${lookup(var.optional_parameters, "rds_cluster_param_group_name", "${var.custom_identifier}")}"
  family    = "${lookup(var.optional_parameters, "rds_cluster_db_group_family", "aurora5.6")}"
  parameter = ["${var.rds_cluster_db_param_group_params}"]
  tags      = "${var.db_tags}"
}

resource "random_string" "final_snapshot_identifier_default_gen_id" {
  length = 16
  special = false
}

resource "aws_rds_cluster" "rds_db_cluster" {
  // Note: username length must be between 2 and 16 character or AWS return an error
  master_username = "${local.master_username}"
  master_password = "${var.master_password}"

  cluster_identifier                  = "${lookup(var.optional_parameters, "cluster_identifier", "${var.custom_identifier}-cluster")}"
  engine                              = "${local.engine}"
  engine_version                      = "${local.engine_version}"
  # Engine mode can be provisioned, serverless, parallelquery and global. https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/aurora-serverless.html https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/aurora-mysql-parallel-query.html
  engine_mode                         = "${local.engine_mode}"
  database_name                       = "${lookup(var.optional_parameters, "database_name", "")}"
  availability_zones                  = ["${var.availability_zones}"]
  port                                = "${lookup(var.optional_parameters, "port", 3306)}"

  snapshot_identifier                 = "${lookup(var.optional_parameters, "snapshot_identifier", "")}"
  final_snapshot_identifier           = "${lookup(var.optional_parameters, "final_snapshot_identifier", "${var.custom_identifier}-${random_string.final_snapshot_identifier_default_gen_id.result}")}"
  skip_final_snapshot                 = "${lookup(var.optional_parameters, "skip_final_snapshot", false)}"

  apply_immediately                   = "${lookup(var.optional_parameters, "apply_immediately", false)}"
  db_subnet_group_name                = "${aws_db_subnet_group.db_subnet_group.name}"
  db_cluster_parameter_group_name     = "${var.db_cluster_parameter_group_name == "" ? var.db_cluster_parameter_group_name : element(concat(aws_rds_cluster_parameter_group.rds_cluster_param_group.*.name, list("")), 0)}"

  vpc_security_group_ids              = ["${local.security_groups_vpc_ids}"]
  storage_encrypted                   = "${lookup(var.optional_parameters, "storage_encrypted", true)}"
  kms_key_id                          = "${lookup(var.optional_parameters, "kms_key_id", "")}"
  iam_database_authentication_enabled = "${lookup(var.optional_parameters, "iam_database_authentication_enabled", false)}"
  iam_roles                           = "${var.iam_roles}"
  enabled_cloudwatch_logs_exports     = ["${var.enabled_cloudwatch_logs_exports}"]

  backup_retention_period             = "${lookup(var.optional_parameters, "backup_retention_period", 14)}"
  preferred_backup_window             = "${lookup(var.optional_parameters, "preferred_backup_window", "")}"
  preferred_maintenance_window        = "${lookup(var.optional_parameters, "preferred_maintenance_window", "")}"

  deletion_protection                 = "${lookup(var.optional_parameters, "deletion_protection", false)}"
  backtrack_window                    = "${lookup(var.optional_parameters, "backtrack_window", 0)}"

  scaling_configuration = "${var.scaling_configuration}"

  source_region                 = "${lookup(var.optional_parameters, "source_region", "")}"
  replication_source_identifier = "${lookup(var.optional_parameters, "replication_source_identifier", "")}"

  tags = "${var.db_tags}"

  lifecycle {
    ignore_changes = ["master_password"]
  }

  depends_on = ["aws_rds_cluster_parameter_group.rds_cluster_param_group", "aws_db_subnet_group.db_subnet_group"]
}

resource "aws_rds_cluster_instance" "rds_db_cluster_instance" {
  cluster_identifier = "${aws_rds_cluster.rds_db_cluster.id}"

  count                        = "${var.instances_count}"
  identifier                   = "${lookup(var.optional_parameters, "cluster_instance_identifier", "${var.custom_identifier}")}-${count.index}"
  engine                       = "${local.engine}"
  engine_version               = "${local.engine_version}"
  instance_class               = "${lookup(var.optional_parameters, "instance_class", "db.r3.large")}"
  publicly_accessible          = "${lookup(var.optional_parameters, "publicly_accessible", false)}"
  db_subnet_group_name         = "${aws_db_subnet_group.db_subnet_group.name}"
  db_parameter_group_name      = "${var.db_parameter_group_name == "" ? var.db_parameter_group_name : element(concat(aws_db_parameter_group.rds_cluster_db_param_group.*.name, list("")), 0)}"
  apply_immediately            = "${lookup(var.optional_parameters, "apply_immediately", false)}"
  monitoring_role_arn          = "${lookup(var.optional_parameters, "monitoring_role_arn", "")}"
  monitoring_interval          = "${lookup(var.optional_parameters, "monitoring_interval", 0)}"
  promotion_tier               = "${lookup(var.optional_parameters, "promotion_tier", 0)}"
  auto_minor_version_upgrade   = "${lookup(var.optional_parameters, "auto_minor_version_upgrade", true)}"
  performance_insights_enabled = "${lookup(var.optional_parameters, "performance_insights_enabled", false)}"
  copy_tags_to_snapshot        = "${lookup(var.optional_parameters, "copy_tags_to_snapshot", true)}"

  tags = "${var.db_tags}"

  depends_on = ["aws_rds_cluster.rds_db_cluster", "aws_db_parameter_group.rds_cluster_db_param_group"]
}
