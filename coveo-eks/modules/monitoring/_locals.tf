locals {
  prometheus_url_default_region = "monitoring.${var.infra_domain_name}"
  prometheus_url_not_default_region = "monitoring-${var.cluster_name}.${var.infra_domain_name}"
  prometheus_url = "${var.is_default_region ? local.prometheus_url_default_region : local.prometheus_url_not_default_region}"

  alertmanager_url_default_region = "alertmanager.${var.infra_domain_name}"
  alertmanager_url_not_default_region = "alertmanager-${var.cluster_name}.${var.infra_domain_name}"
  alertmanager_url = "${var.is_default_region ? local.alertmanager_url_default_region : local.alertmanager_url_not_default_region}"

  grafana_url_default_region = "grafana.${var.infra_domain_name}"
  grafana_url_not_default_region = "grafana-${var.cluster_name}.${var.infra_domain_name}"
  grafana_url = "${var.is_default_region ? local.grafana_url_default_region : local.grafana_url_not_default_region}"
}
