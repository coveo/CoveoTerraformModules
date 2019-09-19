variable "namespace" {
  default     = "infrastructure"
  description = "Define in which namespace ingress controller will be deployed"
}

variable "cluster_name" {
  description = "Name of the previously created EKS cluster"
}

variable "iam_assume_role_arn" {
  description = "Arn of the IAM role to allow to assuming the ingress controller's role"
}

variable "ingress_controller_docker" {
  default = {
    image = "quay.io/coreos/alb-ingress-controller"
    tag   = "v1.0.0"
  }

  description = "ingress controller docker configuration"
}

variable "vpc_id" {
  description = "VPC ID of the current region"
}

# Do not use region or region_name here or else you will have a "Variable names must be unique." error
variable "region_id" {
  description = "Region in which this controller is deployed"
}
