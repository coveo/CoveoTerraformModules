output "role_name" {
  description = "The name of the role that the app must use to run"
  value       = "${aws_iam_role.cluster_autoscaler.name}"
}

output "role_arn" {
  description = "The name of the role that the app must use to run"
  value       = "${aws_iam_role.cluster_autoscaler.arn}"
}
