output "secret_name" {
  value       = "${kubernetes_secret.secret_thanos.metadata.0.name}"
  description = "Thanos secret name"
}

output "secret_version" {
  value       = "${kubernetes_secret.secret_thanos.metadata.0.resource_version}"
  description = "Thanos secret version"
}

output "iam_role" {
  value       = "${aws_iam_role.thanos_bucket.name}"
  description = "Thanos IAM role"
}
