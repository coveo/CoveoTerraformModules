variable "namespace" {
  default = "monitoring"
}

variable "cluster_name" {
  description = "Name of the previously created EKS cluster"
}

variable "iam_assume_role_arn" {
  description = "Arn of the IAM role to allow to assuming the thanos and r53_exporter roles"
}

variable "domain_id" {
  description = "Route 53 infra domain ID"
}

variable "domain_name" {
  description = "R53 domain name"
}

variable "http_port" {
  description = "Port used by thanos for HTTP communication"
  default = "19191"
}

variable "grpc_port" {
  description = "Port used by thanos for gRPC communication"
  default = "19090"
}

variable "thanos_version" {
  description = "Version of image to use for thanos"
  default     = "v0.6.0"
}

variable "thanos_image" {
  description = "Image to use for thanos"
  default     = "improbable/thanos"
}

variable "manage_bucket" {
  description = "Manage the bucket needed by Thanos. This will create the bucket and also thanos compactor because it needs to be a singleton."
  default     = false
}

variable "r53_srvupdater_version" {
  description = "Version used by the r53-srvupdater container"
  default     = "v0.6"
}

variable "deploy_querier" {
  description = "Deploy the querier for Thanos"
  default     = false
}

variable "deploy_store" {
  description = "Deploy the store for Thanos"
  default     = false
}

variable "retention_resolution_raw" {
  description = "How long to retain raw samples in bucket. 0d - disables this retention. Only useful when manage_bucket is true."
  default     = "0d"
}

variable "retention_resolution_5m" {
  description = "How long to retain samples of resolution 1 (5 minutes) in bucket. 0d - disables this retention. Only useful when manage_bucket is true."
  default     = "0d"
}

variable "retention_resolution_1h" {
  description = "How long to retain samples of resolution 2 (1 hour) in bucket. 0d - disables this retention. Only useful when manage_bucket is true."
  default     = "0d"
}

variable "node_security_group" {
  description = "Node security group id. This will allow DEP to connect to this cluster"
}

variable "deployment_cidr" {
  description = "CIDR of the deployment subnet"
  default     = "10.20.0.0/16"
}

variable "create_dep_security_rule" {
  description = "Create the security group rule to enable the connection from DEP"
  default     = true
}

variable "sidecar_basename" {
  description = "Used for the sidecar service to enable thanos_store to comunicate with both sidecars"
  # PS : Don't blame me for this name, it's prometheus' operator fault :)
  default     = "prometheus-prometheus-operator-promet-prometheus"
}
