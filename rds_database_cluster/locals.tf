locals {
  # https://www.terraform.io/docs/providers/aws/r/rds_cluster.html#engine_mode
  # global, multimaster, parallelquery, provisioned, serverless.
  engine_mode = "${lookup(var.optional_parameters, "engine_mode", "provisioned")}"

  # https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/AuroraMySQL.Updates.html
  # https://www.terraform.io/docs/providers/aws/r/rds_cluster.html#engine
  # Engine aurora refers to Aurora MySQL 1.x and aurora-mysql refers to 2.x
  engine = "${lookup(var.optional_parameters, "engine", "aurora")}"
  # To use Aurora 1.x set 5.6.10a or higher
  # To use Aurora 2.x set the MySQL version to 5.7.12 or higher
  engine_version = "${lookup(var.optional_parameters, "engine_version", "5.6.10a")}"

  instances_count = "${local.engine_mode == "serverless" ? 0 : var.instances_count}"
  snapshot_identifier_found = "${lookup(var.optional_parameters, "snapshot_identifier", "") == "" ? false : true}"
  internal_security_groups_vpc_ids = ["${element(concat(aws_security_group.rds_cluster_security_group.*.id, list("")), 0)}"]
  security_groups_vpc_ids = ["${concat(local.internal_security_groups_vpc_ids, var.vpc_security_group_ids)}"]

  master_username = "${lookup(var.optional_parameters, "master_username", "root")}"

  master_secret_value_map = {
    username = "${local.master_username}"
    password = "${var.master_password}",
    engine = "${local.engine}",
    host = "${aws_rds_cluster.rds_db_cluster.endpoint}",
    port = "${aws_rds_cluster.rds_db_cluster.port}",
    dbClusterIdentifier = "${aws_rds_cluster.rds_db_cluster.cluster_identifier}"
  }
}