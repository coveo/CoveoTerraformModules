output "prometheus_url" {
  value       = "${local.prometheus_url}"
  description = "URL of prometheus endpoint"
}

output "alertmanager_url" {
  value       = "${local.alertmanager_url}"
  description = "URL of alertmanager endpoint"
}

output "grafana_url" {
  value       = "${local.grafana_url}"
  description = "URL of grafana endpoint"
}
