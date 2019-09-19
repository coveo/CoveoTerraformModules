resource "quantum_password" "grafana_password" {
  special_chars = "!#*+-"
}

resource "aws_ssm_parameter" "grafana_username" {
  count = "${var.enable_grafana ? 1 : 0}"
  name  = "/${var.env}/kubernetes/${var.cluster_name}/logstack/grafana_username"
  value = "admin"
  type  = "String"
}

resource "aws_ssm_parameter" "grafana_password" {
  count   = "${var.enable_grafana ? 1 : 0}"
  name    = "/${var.env}/kubernetes/${var.cluster_name}/logstack/grafana_password"
  type    = "SecureString"
  value   = "${quantum_password.grafana_password.password}"
  key_id  = "${var.infra_kms_infra_key_id}"
}
