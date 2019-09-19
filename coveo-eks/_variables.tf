variable "cluster_name" {
  description = "Name of the EKS cluster. Also used as a prefix in names of related resources."
}

variable "cluster_version" {
  description = "Kubernetes version to use for the EKS cluster."
  default     = "1.13"
}

## Logs disabled until managed by Security SIEM, add back ["audit"] when ready
variable "cluster_enabled_log_types" {
  description = "List of enabled log type for the EKS cluster"
  type        = "list"
  default     = []
}

variable "tags" {
  description = "A map of tags to add to all resources."
  type        = "map"
  default     = {}
}

variable "worker_groups" {
  description = "A list of maps defining worker group configurations to be defined using AWS Launch Configurations. See workers_group_defaults for valid keys."
  type        = "list"

  default = [
    {
      "name" = "default"
    },
    {},
  ]
}

variable "worker_group_tags" {
  description = "A map defining extra tags to be applied to the worker group ASG."
  type        = "map"

  default = {
    default = []
  }
}

variable "worker_ami_name_filter" {
  description = "Additional name filter for AWS EKS worker AMI. Default behaviour will get latest for the cluster_version but could be set to a release from amazon-eks-ami, e.g. \"v20190220\""
  default     = "v*"
}

variable "worker_additional_security_group_ids" {
  description = "A list of additional security group ids to attach to worker instances"
  type        = "list"
  default     = []
}

variable "workers_additional_policies" {
  description = "Additional policies to be added to workers"
  type        = "list"
  default     = []
}

variable "workers_additional_policies_count" {
  default = 0
}

variable "namespaces" {
  description = "Namespaces to create in kubernetes cluster"
  type        = "list"
  default     = []
}

variable "calico_manifest_url" {
  description = "Path or url to the calico deployment manifest. By default, use the one given by AWS"
  default     = "https://raw.githubusercontent.com/aws/amazon-vpc-cni-k8s/release-1.5/config/v1.5/calico.yaml"
}

variable "cni_version" {
  description = "AWS cni version"
  default     = "1.5"
}

variable "kube_proxy_version" {
  description = "Kube-proxy version to deploy into the cluster"
  default     = "1.13.7"
}

variable "coredns_version" {
  description = "CoreDNS version to deploy into the cluster"
  default     = "1.2.6"
}

variable "domain_id" {
  description = "R53 domain id"
  default     = "ABDC12345"
}

variable "domain_name" {
  description = "R53 domain name"
  default     = "dev.example.com"
}

variable "elasticsearch_cluster_url" {
  description = "URL of elasticsearch to send logs to"
}

variable "clusters_subnets" {
  description = "Subnet where asg created in"
  type        = "list"
}

variable "kiam_key_name" {
  description = "SSH key name to use for kiam node"
}

variable "filebeat_deploy_resources" {
  default = {
    request_cpu    = "0.1"
    request_memory = "100Mi"
    limit_cpu      = "1"
    limit_memory   = "200Mi"
  }

  description = "filebeat pod resources configurations"
}

variable "redis_logs_endpoint" {
  description = "URL for redis endpoint to send logs to"
}

variable "prometheus_deploy_resources" {
  description = "Resources limit for prometheus"

  default = {
    request_cpu    = "1000m"
    request_memory = "4000Mi"
    limit_cpu      = "2000m"
    limit_memory   = "8000Mi"
  }
}

variable "prometheus_retention" {
  description = "Retention of metrics"
  default     = "360h"
}

variable "allowed_monitoring_cidr" {
  description = "Allow these subnets to connect to monitoring tools"
  default     = []
}

# Do not use region or region_name here or else you will have a "Variable names must be unique." error
variable "region_id" {
  description = "Region in which this module is deployed"
}

variable "vpc_id" {
  description = "VPC ID of the current region"
}

variable "scale_down_utilization_threshold" {
  description = "Node utilization level, defined as sum of requested resources divided by capacity, below which a node can be considered for scale down"
  default     = "0.5"
}

variable "use_ubuntu_ami" {
  description = "Use or not Coveo's Ubuntu AMI for EKS worker"
  default     = false
}

variable "thanos_version" {
  description = "Version of image to use for thanos"
  default     = "v0.4.0"
}

variable "thanos_image" {
  description = "Image to use for thanos"
  default     = "improbable/thanos"
}

variable "thanos_manage_bucket" {
  description = "Manage the bucket needed by Thanos. This will create the bucket and also thanos compactor because it needs to be a singleton."
  default     = false
}

variable "thanos_deploy_querier" {
  description = "Deploy the thanos querier for this cluster"
  default     = false
}

variable "thanos_deploy_store" {
  description = "Deploy the thanos store for this cluster"
  default     = false
}

variable "thanos_retention_resolution_raw" {
  description = "How long to retain raw samples in bucket. 0d - disables this retention. Only useful when thanos_manage_bucket is true."
  default     = "0d"
}

variable "thanos_retention_resolution_5m" {
  description = "How long to retain samples of resolution 1 (5 minutes) in bucket. 0d - disables this retention. Only useful when thanos_manage_bucket is true."
  default     = "0d"
}

variable "thanos_retention_resolution_1h" {
  description = "How long to retain samples of resolution 2 (1 hour) in bucket. 0d - disables this retention. Only useful when thanos_manage_bucket is true."
  default     = "0d"
}

variable "enable_grafana" {
  description = "Enable the deployment of Grafana"
  default     = false
}
