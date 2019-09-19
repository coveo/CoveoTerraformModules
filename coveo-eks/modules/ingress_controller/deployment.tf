resource "kubernetes_deployment" "alb_ingress_controller" {
  metadata {
    name      = "alb-ingress-controller"
    namespace = "${var.namespace}"

    labels {
      app       = "alb-ingress-controller"
      component = "controller"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels {
        app       = "alb-ingress-controller"
        component = "controller"
      }
    }

    template {
      metadata {
        labels {
          app       = "alb-ingress-controller"
          component = "controller"
        }

        annotations {
          "iam.amazonaws.com/role" = "${aws_iam_role.eks_alb_controller.name}"
        }
      }

      spec {
        container {
          name  = "alb-ingress-controller"
          image = "${var.ingress_controller_docker["image"]}:${var.ingress_controller_docker["tag"]}"
          args  = [
            "/server",
            "--cluster-name=${var.cluster_name}",
            "--ingress-class=alb",
            "--aws-vpc-id=${var.vpc_id}",
            "--aws-region=${var.region_id}",
            # Max length of alb-name-prefix is 12 characters, default is 8 chars long
            "--alb-name-prefix=${substr(sha1(var.cluster_name), 0, 8)}"
          ]

          port {
            container_port = 10254
            protocol       = "TCP"
          }

          env {
            name = "POD_NAME"

            value_from {
              field_ref {
                api_version = "v1"
                field_path  = "metadata.name"
              }
            }
          }

          env {
            name = "POD_NAMESPACE"

            value_from {
              field_ref {
                api_version = "v1"
                field_path  = "metadata.namespace"
              }
            }
          }

          resources {
            limits {
              cpu    = "100m"
              memory = "100Mi"
            }

            requests {
              cpu    = "100m"
              memory = "100Mi"
            }
          }

          liveness_probe {
            http_get {
              path   = "/healthz"
              port   = "10254"
              scheme = "HTTP"
            }

            initial_delay_seconds = 60
            timeout_seconds       = 1
            period_seconds        = 60
            success_threshold     = 1
            failure_threshold     = 3
          }

          readiness_probe {
            http_get {
              path   = "/healthz"
              port   = "10254"
              scheme = "HTTP"
            }

            initial_delay_seconds = 30
            timeout_seconds       = 3
            period_seconds        = 10
            success_threshold     = 1
            failure_threshold     = 3
          }

          termination_message_path = "/dev/termination-log"
          image_pull_policy        = "IfNotPresent"
        }

        restart_policy                   = "Always"
        termination_grace_period_seconds = 60
        dns_policy                       = "ClusterFirst"
        service_account_name             = "alb-ingress-controller"
        automount_service_account_token  = true
      }
    }

    strategy {
      type = "RollingUpdate"

      rolling_update {
        max_unavailable = "1"
        max_surge       = "1"
      }
    }

    revision_history_limit    = 10
    progress_deadline_seconds = 600
  }
}