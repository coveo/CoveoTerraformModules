data "template_file" "filebeat_config" {
  template = "${file("${path.module}/files/filebeat.yaml")}"

  vars {
    user                            = "${aws_ssm_parameter.filebeat_username.value}"
    password                        = "${quantum_password.filebeat_password.password}"
    queue_mem_maxevents             = "${var.filebeat_configs["queue_mem_maxevents"]}"
    queue_mem_flush_min_events      = "${var.filebeat_configs["queue_mem_flush_min_events"]}"
    queue_mem_flush_timeout         = "${var.filebeat_configs["queue_mem_flush_timeout"]}"
    inputs_enabled                  = "${var.filebeat_configs["inputs_enabled"]}"
    inputs_reload_period            = "${var.filebeat_configs["inputs_reload_period"]}"
    shutdown_timeout                = "${var.filebeat_configs["shutdown_timeout"]}"
    xpack_monitoring_enabled        = "${var.filebeat_configs["xpack_monitoring_enabled"]}"
    elasticsearch_cluster_url       = "${var.elasticsearch_cluster_url}"
    xpack_monitoring_max_retries    = "${var.filebeat_configs["xpack_monitoring_max_retries"]}"
    xpack_monitoring_bulk_max_size  = "${var.filebeat_configs["xpack_monitoring_bulk_max_size"]}"
    xpack_monitoring_timeout        = "${var.filebeat_configs["xpack_monitoring_timeout"]}"
    xpack_monitoring_ssl            = "${var.filebeat_configs["xpack_monitoring_ssl"]}"
    http_port                       = "${var.filebeat_configs["http_port"]}"
    redis_logs_endpoint             = "${var.redis_logs_endpoint}"
  }
}

resource "kubernetes_secret" "filebeat" {
  metadata {
    name      = "filebeatconfig"
    namespace = "${var.namespace}"
  }

  type = "Opaque"

  data {
    "filebeat.yml" = "${data.template_file.filebeat_config.rendered}"
  }
}
