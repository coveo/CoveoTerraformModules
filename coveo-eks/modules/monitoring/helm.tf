data "template_file" "prometheus_values" {
  template = "${file("${path.module}/files/values_prometheus.yaml")}"

  vars {
    # Prometheus specific variables
    "prometheus_resources_limit_cpu"   = "${var.prometheus_deploy_resources["limit_cpu"]}"
    "prometheus_resources_limit_mem"   = "${var.prometheus_deploy_resources["limit_memory"]}"
    "prometheus_resources_request_cpu" = "${var.prometheus_deploy_resources["request_cpu"]}"
    "prometheus_resources_request_mem" = "${var.prometheus_deploy_resources["request_memory"]}"
    "prometheus_version"               = "${var.prometheus_version}"
    "prometheus_url"                   = "${local.prometheus_url}"
    "prometheus_retention"             = "${var.prometheus_retention}"
    "cleanupCustomResource"            = "${var.prometheus_cleanup_custom_resource}"

    # Prometheus operator specific variables
    "operator_resources_limit_cpu"   = "${var.prometheus_operator_deploy_resources["limit_cpu"]}"
    "operator_resources_limit_mem"   = "${var.prometheus_operator_deploy_resources["limit_memory"]}"
    "operator_resources_request_cpu" = "${var.prometheus_operator_deploy_resources["request_cpu"]}"
    "operator_resources_request_mem" = "${var.prometheus_operator_deploy_resources["request_memory"]}"
    "prometheus_operator_version"    = "${var.prometheus_operator_version}"

    # Grafana specific variables
    "enable_grafana"  = "${var.enable_grafana}"

    # Thanos specific variables
    "thanos_version"             = "${var.thanos_version}"
    "thanos_image"               = "${var.thanos_image}"
    "thanos_sidecar_limit_cpu"   = "${var.thanos_sidecar_resources["limit_cpu"]}"
    "thanos_sidecar_limit_mem"   = "${var.thanos_sidecar_resources["limit_memory"]}"
    "thanos_sidecar_request_cpu" = "${var.thanos_sidecar_resources["request_cpu"]}"
    "thanos_sidecar_request_mem" = "${var.thanos_sidecar_resources["request_memory"]}"
    "thanos_secret_name"         = "${var.thanos_secret_name}"
    "thanos_secret_version"      = "${var.thanos_secret_version}"
    "thanos_iam_role"            = "${var.thanos_iam_role}"
    # Common variables
    "environment" = "${var.env}"
    "region"      = "${var.region}"
    "namespace"   = "${var.namespace}"
    "cluster"     = "${var.cluster_name}"
  }
}

resource "helm_release" "prometheus_operator" {
  count     = "${var.helm_deployed ? 1 : 0}"
  name      = "prometheus-operator"
  chart     = "stable/prometheus-operator"
  namespace = "${var.namespace}"
  version   = "6.6.0"

  values = ["${data.template_file.prometheus_values.rendered}"]
}

data "template_file" "prometheus_adapter_values" {
  template = "${file("${path.module}/files/values_prometheus_adapter.yaml")}"

  vars {
    "prom_adapter_resources_limit_cpu"   = "${var.prometheus_adapter_deploy_resources["limit_cpu"]}"
    "prom_adapter_resources_limit_mem"   = "${var.prometheus_adapter_deploy_resources["limit_memory"]}"
    "prom_adapter_resources_request_cpu" = "${var.prometheus_adapter_deploy_resources["request_cpu"]}"
    "prom_adapter_resources_request_mem" = "${var.prometheus_adapter_deploy_resources["request_memory"]}"

    # Common variables
    "environment" = "${var.env}"
    "region"      = "${var.region}"
    "namespace"   = "${var.namespace}"
  }
}

resource "helm_release" "prometheus_adapter" {
  count     = "${var.helm_deployed ? 1 : 0}"
  name      = "prometheus-adapter"
  chart     = "stable/prometheus-adapter"
  namespace = "${var.namespace}"

  values = ["${data.template_file.prometheus_adapter_values.rendered}"]
}
