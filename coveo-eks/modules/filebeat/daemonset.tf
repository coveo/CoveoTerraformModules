resource "kubernetes_daemonset" "filebeat" {
  depends_on = ["kubernetes_secret.filebeat","kubernetes_config_map.inputsconfig"]
  metadata {
    name      = "filebeat"
    namespace = "${var.namespace}"
  }
  spec {
    selector {
      match_labels {
        app = "filebeat"
      }
    }
    template {
      metadata {
        name = "filebeat"
        labels {
          app = "filebeat"
        }
        annotations {
          cm_version     = "${kubernetes_config_map.inputsconfig.metadata.0.resource_version}"
          secret_version = "${kubernetes_secret.filebeat.metadata.0.resource_version}"
        }
      }

      spec {
        automount_service_account_token = true
        toleration {
          operator = "Exists"
        }
        service_account_name = "filebeat"
        volume {
          name = "varlog"
          host_path {
            path = "/var/log"
          }
        }
        volume {
          name = "varlibdockercontainers"
          host_path {
            path = "/var/lib/docker/containers"
          }
        }
        volume {
          name = "inputsconfig"

          config_map {
            name         = "inputsconfig"
            default_mode = "0661"
          }
        }
        volume {
          name = "filebeatconfig"
          secret {
            secret_name  = "filebeatconfig"
            default_mode = "0661"
          }
        }
        volume {
          name = "data"
          host_path {
            path = "/opt/filebeat/data"
          }
        }
        container {
          name  = "filebeat"
          image = "${var.filebeat_docker["image"]}:${var.filebeat_docker["tag"]}"
          args  = ["-strict.perms=false", "-e"]

          port {
            container_port = "${var.filebeat_configs["http_port"]}"
          }

          env {
            name  = "ENVIRONMENT"
            value = "${var.env}"
          }

          env {
            name = "POD_NAME"
            value_from {
              field_ref {
                field_path = "metadata.name"
              }
            }
          }

          env {
            name = "NODE_NAME"
            value_from {
              field_ref {
                field_path = "spec.nodeName"
              }
            }
          }

          resources {
            limits {
              cpu    = "${var.filebeat_deploy_resources["limit_cpu"]}"
              memory = "${var.filebeat_deploy_resources["limit_memory"]}"
            }

            requests {
              cpu    = "${var.filebeat_deploy_resources["request_cpu"]}"
              memory = "${var.filebeat_deploy_resources["request_memory"]}"
            }
          }

          volume_mount {
            name       = "varlog"
            mount_path = "/var/log"
          }

          volume_mount {
            name       = "varlibdockercontainers"
            read_only  = true
            mount_path = "/var/lib/docker/containers"
          }

          volume_mount {
            name       = "inputsconfig"
            mount_path = "/usr/share/filebeat/config/inputs.d"
          }

          volume_mount {
            name       = "filebeatconfig"
            mount_path = "/usr/share/filebeat/filebeat.yml"
            sub_path   = "filebeat.yml"
          }

          volume_mount {
            name       = "data"
            mount_path = "/usr/share/filebeat/data"
          }
        }

        security_context {
          fs_group = 1000
        }
      }
    }

    strategy {
      type = "RollingUpdate"
    }
  }
}
