resource "quantum_password" "filebeat_password" {
  special_chars = "!#*+-"
}

resource "aws_ssm_parameter" "filebeat_username" {
  name  = "/${var.env}/kubernetes/${var.cluster_name}/logstack/filebeat_username"
  value = "${var.prefix}_svc_filebeat"
  type  = "String"
}

resource "aws_ssm_parameter" "filebeat_password" {
  name   = "/${var.env}/kubernetes/${var.cluster_name}/logstack/filebeat_password"
  type   = "SecureString"
  value  = "${quantum_password.filebeat_password.password}"
  key_id = "${var.infra_kms_infra_key_id}"
}
