## EKS module output "cloudwatch_log_group_name" Unavailable in V4, available in V5
#output "cloudwatch_log_group_name" {
#  description = "Name of cloudwatch log group created."
#  value       = "${module.k8s-cluster.cloudwatch_log_group_name}"
#}

output "cloudwatch_log_group_name" {
  description = "Name of cloudwatch log group created."
  value       = "/aws/eks/${module.k8s-cluster.cluster_id}/cluster"
}

output "cluster_id" {
  description = "The name/id of the EKS cluster."
  value       = "${module.k8s-cluster.cluster_id}"
}

output "cluster_arn" {
  description = "The Amazon Resource Name (ARN) of the cluster."
  value       = "${module.k8s-cluster.cluster_arn}"
}

output "cluster_certificate_authority_data" {
  description = "Nested attribute containing certificate-authority-data for your cluster. This is the base64 encoded certificate data required to communicate with your cluster."
  value       = "${module.k8s-cluster.cluster_certificate_authority_data}"
}

output "cluster_endpoint" {
  description = "The endpoint for your EKS Kubernetes API."
  value       = "${module.k8s-cluster.cluster_endpoint}"
}

output "cluster_version" {
  description = "The Kubernetes server version for the EKS cluster."
  value       = "${module.k8s-cluster.cluster_version}"
}

output "cluster_security_group_id" {
  description = "Security group ID attached to the EKS cluster."
  value       = "${module.k8s-cluster.cluster_security_group_id}"
}

output "cluster_iam_role_name" {
  description = "IAM role name of the EKS cluster."
  value       = "${module.k8s-cluster.cluster_iam_role_name}"
}

output "cluster_iam_role_arn" {
  description = "IAM role ARN of the EKS cluster."
  value       = "${module.k8s-cluster.cluster_iam_role_arn}"
}

output "workers_asg_arns" {
  description = "IDs of the autoscaling groups containing workers."
  value       = "${module.k8s-cluster.workers_asg_arns}"
}

output "workers_asg_names" {
  description = "Names of the autoscaling groups containing workers."
  value       = "${module.k8s-cluster.workers_asg_names}"
}

output "workers_user_data" {
  description = "User data of worker groups"
  value       = "${module.k8s-cluster.workers_user_data}"
}

output "workers_default_ami_id" {
  description = "ID of the default worker group AMI"
  value       = "${module.k8s-cluster.workers_default_ami_id}"
}

output "workers_launch_template_ids" {
  description = "IDs of the worker launch templates."
  value       = "${module.k8s-cluster.workers_launch_template_ids}"
}

output "workers_launch_template_arns" {
  description = "ARNs of the worker launch templates."
  value       = "${module.k8s-cluster.workers_launch_template_arns}"
}

output "workers_launch_template_latest_versions" {
  description = "Latest versions of the worker launch templates."
  value       = "${module.k8s-cluster.workers_launch_template_latest_versions}"
}

output "worker_security_group_id" {
  description = "Security group ID attached to the EKS workers."
  value       = "${module.k8s-cluster.worker_security_group_id}"
}

output "worker_iam_instance_profile_arns" {
  description = "default IAM instance profile ARN for EKS worker groups"
  value       = "${module.k8s-cluster.worker_iam_instance_profile_arns}"
}

output "worker_iam_instance_profile_names" {
  description = "default IAM instance profile name for EKS worker groups"
  value       = "${module.k8s-cluster.worker_iam_instance_profile_names}"
}

output "worker_iam_role_name" {
  description = "default IAM role name for EKS worker groups"
  value       = "${module.k8s-cluster.worker_iam_role_name}"
}

output "worker_iam_role_arn" {
  description = "default IAM role ARN for EKS worker groups"
  value       = "${module.k8s-cluster.worker_iam_role_arn}"
}

output "cluster_namespaces" {
  description = "All namespaces created in the cluster"
  value       = "${concat(list("infrastructure", "csec" , "monitoring", "ingress"), var.namespaces)}"
}

output "worker_ami_id" {
  description = "AMI id used for kubernetes worker"
  value       = "${var.use_ubuntu_ami ? data.aws_ami.ubuntu.image_id : module.k8s-cluster.workers_default_ami_id}"
}
