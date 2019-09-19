variable "namespace" {
  default = "kube-system"
}

variable "image" {
  description = "Operator's image parameters"

  default = {
    repository  = "coveo/aws-auth-operator"
    tag         = "0.2"
    pull_policy = "IfNotPresent"
  }
}

variable "deploy_resources" {
  description = "Operator's pod resources"

  default = {
    request_cpu    = "50m"
    request_memory = "64Mi"
    limit_cpu      = "100m"
    limit_memory   = "128Mi"
  }
}
