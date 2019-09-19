variable "namespace" {
  default     = "infrastructure"
  description = "Define in which namespace ingress controller will be deployed"
}

variable "helm_deployed" {
  default     = false
  description = "ensure dependency with Tiller"
}

variable "domain_id" {
  description = "R53 domain id"
  default     = "ABDC12345"
}

variable "domain_name" {
  description = "R53 domain name"
  default     = "dev.example.com"
}

variable "cluster_name" {
  description = "Name of the kubernetes cluster"
  default     = "eks.dev.example.com"
}

variable "iam_assume_role_arn" {
  description = "Arn of the IAM role to allow to assuming the external-dns's role"
}
