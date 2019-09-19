variable "namespace" {
  default     = "infrastructure"
  description = "Define in which namespace logstash will be deployed"
}

variable "cluster_name" {
  description = "Name of the previously created EKS cluster"
}

variable "filebeat_docker" {
  default = {
    image = "docker.elastic.co/beats/filebeat"
    tag   = "7.2.0"
  }

  description = "filebeat docker configurations"
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

variable "filebeat_configs" {
  default = {
    http_port                      = "5066"
    inputs_enabled                 = "true"
    inputs_reload_enabled          = "true"
    inputs_reload_period           = "10s"
    queue_mem_maxevents            = "4096"
    queue_mem_flush_min_events     = "2048"
    queue_mem_flush_timeout        = "1s"
    shutdown_timeout               = "10s"
    xpack_monitoring_enabled       = "false"
    xpack_monitoring_max_retries   = "3"
    xpack_monitoring_bulk_max_size = "50"
    xpack_monitoring_timeout       = "90"
    xpack_monitoring_ssl           = "true"
  }

  description = "filebeat process configurations"
}

variable "logstack_elasticport" {
  default     = "9200"
  description = "Elasticsearhc cluster API port"
}

variable "kube_system_log_enabled" {
  default     = false
  description = "Feature flag - enable k8s system logs"
}

variable "kube_audit_log_enabled" {
  default     = true
  description = "Feature flag - enable k8s system logs"
}

variable "elasticsearch_cluster_url" {
  description = "URL of elasticsearch to send logs to"  
}

variable "redis_logs_endpoint" {
  description = "URL for redis endpoint to send logs to"
}
