output "filebeat_monitor_port" {
  value       = "${var.filebeat_configs["http_port"]}"
  description = "Monitoring port of Filebeat daemontset"
}

output "filebeat_username_path" {
  value = "${aws_ssm_parameter.filebeat_username.name}"
}


output "filebeat_password_path" {
  value = "${aws_ssm_parameter.filebeat_password.name}"
}
