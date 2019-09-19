variable "namespace" {
  default     = "kube-system"
  description = "Define in which namespace metrics_server will be deployed"
}

variable "helm_deployed" {
  default     = false
  description = "ensure dependency with Tiller"
}
