resource "kubernetes_deployment" "thanos_r53_srvupdater" {
  metadata {
    name      = "thanos-r53-srvupdater"
    namespace = "${var.namespace}"
    labels {
      role = "r53-srvupdater"
      app  = "thanos"
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels {
        app  = "thanos"
        role = "r53-srvupdater"
      }
    }
    template {
      metadata {
        labels {
          app  = "thanos"
          role = "r53-srvupdater"
        }
        annotations {
          "iam.amazonaws.com/role" = "${aws_iam_role.route53_exporter.name}"
        }
      }
      spec {
        container {
          name  = "thanos-r53-srvupdater"
          image = "coveo/k8s-r53-srvupdate:${var.r53_srvupdater_version}"
          args  = [
            "--namespace",
            "${var.namespace}",
            "--label_selector",
            "app=thanos,thanos-api=true",
            "--srv_record",
            "${local.srv_records}",
            "--r53_zone_id",
            "${var.domain_id}",
            "--k8s_endpoint_name",
            "${var.cluster_name}.${var.region}"
          ]
          resources {
            limits {
              cpu    = "100m"
              memory = "128Mi"
            }

            requests {
              cpu    = "50m"
              memory = "64Mi"
            }
          }
        }
        service_account_name = "r53-thanosupdater"
        automount_service_account_token  = true
      }
    }
  }
}

resource "kubernetes_deployment" "thanos_querier" {
  count = "${var.deploy_querier ? 1 : 0}"

  metadata {
    name      = "thanos-querier"
    namespace = "${var.namespace}"
    labels {
      app = "thanos-querier"
    }
  }
  spec {
    replicas = 2
    selector {
      match_labels {
        app = "thanos-querier"
      }
    }
    template {
      metadata {
        labels {
          app = "thanos-querier"
        }
      }

      spec {
        container {
          name  = "thanos"
          image = "${var.thanos_image}:${var.thanos_version}"
          args  = [
            "query",
            "--log.level=info",
            "--query.replica-label=prometheus_replica",
            "--cluster.disable",
            "--store=dnssrv+${local.srv_records}",
            "--http-address=0.0.0.0:${var.http_port}",
            "--grpc-address=0.0.0.0:${var.grpc_port}"
          ]
          port {
            name           = "http"
            container_port = "${var.http_port}"
          }
          port {
            name           = "grpc"
            container_port = "${var.grpc_port}"
          }
          liveness_probe {
            http_get {
              path = "/-/healthy"
              port = "http"
            }
          }
          resources {
            limits {
              cpu    = "200m"
              memory = "1Gi"
            }
            requests {
              cpu    = "100m"
              memory = "512Mi"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_deployment" "thanos_store" {
  count = "${var.deploy_store ? 1 : 0}"

  metadata {
    name      = "thanos-store"
    namespace = "${var.namespace}"
    labels {
      app = "thanos-store"
    }
  }
  spec {
    replicas = 2
    selector {
      match_labels {
        app = "thanos-store"
      }
    }
    template {
      metadata {
        annotations {
          "iam.amazonaws.com/role"  = "${aws_iam_role.thanos_bucket.name}"
          secret_version            = "${kubernetes_secret.secret_thanos.metadata.0.resource_version}"
        }
        labels {
          app         = "thanos-store"
          thanos-grpc = "true"
        }
      }

      spec {
        container {
          name  = "thanos"
          image = "${var.thanos_image}:${var.thanos_version}"
          args  = [
            "store",
            "--log.level=info",
            "--cluster.disable",
            "--http-address=0.0.0.0:${var.http_port}",
            "--grpc-address=0.0.0.0:${var.grpc_port}",
            "--objstore.config=$$(OBJSTORE_CONFIG)"
          ]
          env {
            name = "OBJSTORE_CONFIG"
            value_from {
              secret_key_ref {
                name = "${kubernetes_secret.secret_thanos.metadata.0.name}"
                key  = "thanos.yaml"
              }
            }
          }
          port {
            name           = "http"
            container_port = "${var.http_port}"
          }
          port {
            name           = "grpc"
            container_port = "${var.grpc_port}"
          }
          resources {
            limits {
              cpu    = "200m"
              memory = "1Gi"
            }
            requests {
              cpu    = "100m"
              memory = "512Mi"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_deployment" "thanos_compactor" {
  # As per the documentation thanos_compactor should only run once for a bucket
  # Because of this only the "manager" will run the compactor
  count = "${var.manage_bucket ? 1 : 0}"

  metadata {
    name      = "thanos-compactor"
    namespace = "${var.namespace}"
    labels {
      app = "thanos-compactor"
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels {
        app = "thanos-compactor"
      }
    }
    strategy {
      # You really must not have more than one pod at any time
      type = "Recreate"
    }
    template {
      metadata {
        annotations {
          "iam.amazonaws.com/role"  = "${aws_iam_role.thanos_bucket.name}"
          secret_version            = "${kubernetes_secret.secret_thanos.metadata.0.resource_version}"
        }
        labels {
          app = "thanos-compactor"
        }
      }
      spec {
        volume {
          name = "datadir"
          empty_dir { }
        }
        container {
          name  = "thanos"
          image = "${var.thanos_image}:${var.thanos_version}"
          args  = [
            "compact",
            "--log.level=info",
            "--http-address=0.0.0.0:${var.http_port}",
            "--objstore.config=$$(OBJSTORE_CONFIG)",
            "--data-dir=/data",
            "--retention.resolution-raw=${var.retention_resolution_raw}",
            "--retention.resolution-5m=${var.retention_resolution_5m}",
            "--retention.resolution-1h=${var.retention_resolution_1h}",
            "--wait"
          ]
          env {
            name = "OBJSTORE_CONFIG"
            value_from {
              secret_key_ref {
                name = "${kubernetes_secret.secret_thanos.metadata.0.name}"
                key  = "thanos.yaml"
              }
            }
          }
          volume_mount {
            name = "datadir"
            mount_path = "/data"
          }
          port {
            name           = "http"
            container_port = "${var.http_port}"
          }
          resources {
            limits {
              cpu    = "200m"
              memory = "1Gi"
            }
            requests {
              cpu    = "100m"
              memory = "512Mi"
            }
          }
        }
      }
    }
  }
}
