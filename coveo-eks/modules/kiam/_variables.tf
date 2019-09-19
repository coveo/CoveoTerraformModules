variable "namespace" {
  default     = "infrastructure"
  description = "Define in which namespace ingress controller will be deployed"
}

variable "helm_deployed" {
  default     = false
  description = "ensure dependency with Tiller"
}

variable "use_ubuntu_ami" {
  description = "Use or not Coveo's Ubuntu AMI for EKS worker"
  default     = false
}
