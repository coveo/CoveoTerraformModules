variable "namespace" {
  default = "infrastructure"
}

variable "cluster_name" {
  description = "Name of the previously created EKS cluster"
}

variable "iam_assume_role_arn" {
  description = "Arn of the IAM role to allow to assuming the external-dns's role"
}

variable "image" {
  description = "Autoscaler image parameters"

  default = {
    repository = "gcr.io/google_containers/cluster-autoscaler"
    tag        = "v1.13.6"
    pullPolicy = "IfNotPresent"
  }
}

variable "deploy_resources" {
  description = "Autoscaler pod resources definition"

  default = {
    request_cpu    = "50m"
    request_memory = "300Mi"
    limit_cpu      = "100m"
    limit_memory   = "300Mi"
  }
}

variable "skipNodesWithLocalStorage" {
  description = "Skip nodes with local storage"
  default     = false
}

variable "skipNodesWithSystemPods" {
  description = "Skip nodes with system storage"
  default     = false
}

variable "scale_down_utilization_threshold" {
  description = "Node utilization level, defined as sum of requested resources divided by capacity, below which a node can be considered for scale down"
  default     = "0.5"
}
