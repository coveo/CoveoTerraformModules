variable "namespace" {
  default = "monitoring"
}

variable "helm_deployed" {
  default     = false
  description = "ensure dependency with Tiller"
}

variable "cluster_name" {
  description = "Name of the previously created EKS cluster"
}

variable "prometheus_operator_deploy_resources" {
  description = "Resources limit for prometheus"

  default = {
    request_cpu    = "20m"
    request_memory = "100Mi"
    limit_cpu      = "100m"
    limit_memory   = "150Mi"
  }
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

variable "prometheus_adapter_deploy_resources" {
  description = "Resources limit for prometheus"

  default = {
    request_cpu    = "100m"
    request_memory = "256Mi"
    limit_cpu      = "200m"
    limit_memory   = "512Mi"
  }
}

variable "prometheus_operator_version" {
  description = "Version of image to use for prometheus-operator and prometheus-config-reloader"
  default     = "v0.31.1"
}

variable "prometheus_version" {
  description = "Version of image to use for prometheus"
  default     = "v2.9.2"
}

variable "prometheus_retention" {
  description = "Retention of metrics"
  default     = "360h"
}

variable "thanos_version" {
  description = "Version of image to use for thanos"
  default     = "v0.6.0"
}

variable "thanos_image" {
  description = "Image to use for thanos"
  default     = "improbable/thanos"
}

variable "thanos_sidecar_resources" {
  default = {
    request_cpu    = "100m"
    request_memory = "512Mi"
    limit_cpu      = "200m"
    limit_memory   = "1024Mi"
  }
}

variable "thanos_secret_name" {
  description = "Name of secret of the thanos module"
}

variable "thanos_secret_version" {
  description = "Secret version of the thanos module"
}

variable "thanos_iam_role" {
  description = "Name of IAM role for thanos"
}

variable "vpc_id" {
  description = "VPC id of current cluster"
}

variable "allowed_monitoring_cidr" {
  description = "Allow these subnets to connect to monitoring tools"
  default     = []
}

variable "enable_grafana" {
  description = "Enable the deployment of Grafana"
  default     = false
}

variable "prometheus_cleanup_custom_resource" {
  description = "WARNING - Will delete all the prometheus' custom resources when release is deleted"

  # Don't commit this as enabled
  default = false
}
