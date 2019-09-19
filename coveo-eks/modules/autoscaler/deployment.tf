resource "kubernetes_deployment" "cluster_autoscaler" {
  metadata {
    name      = "cluster-autoscaler"
    namespace = "${var.namespace}"

    labels {
      app = "cluster-autoscaler"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels {
        app = "cluster-autoscaler"
      }
    }

    template {
      metadata {
        labels {
          app = "cluster-autoscaler"
        }

        annotations {
          "iam.amazonaws.com/role" = "${aws_iam_role.cluster_autoscaler.name}"
        }
      }

      spec {
        automount_service_account_token = true

        volume {
          name = "ssl-certs"

          host_path {
            path = "/etc/ssl/certs/ca-certificates.crt"
          }
        }

        container {
          name  = "cluster-autoscaler"
          image = "${var.image["repository"]}:${var.image["tag"]}"

          command = [
            "./cluster-autoscaler",
            "--v=4",
            "--stderrthreshold=info",
            "--cloud-provider=aws",
            "--expander=least-waste",
            "--balance-similar-node-groups",
            "--node-group-auto-discovery=asg:tag=k8s.io/cluster-autoscaler/enabled,k8s.io/cluster-autoscaler/${var.cluster_name}",
            "--skip-nodes-with-system-pods=${var.skipNodesWithSystemPods}",
            "--skip-nodes-with-local-storage=${var.skipNodesWithLocalStorage}",
            "--scale-down-utilization-threshold=${var.scale_down_utilization_threshold}",
            "--namespace=${var.namespace}",
          ]

          port {
            container_port = 8085
          }

          env {
            name  = "AWS_REGION"
            value = "${var.region}"
          }

          resources {
            limits {
              cpu    = "${var.deploy_resources["limit_cpu"]}"
              memory = "${var.deploy_resources["limit_memory"]}"
            }

            requests {
              cpu    = "${var.deploy_resources["request_cpu"]}"
              memory = "${var.deploy_resources["request_memory"]}"
            }
          }

          volume_mount {
            name       = "ssl-certs"
            read_only  = true
            mount_path = "/etc/ssl/certs/ca-certificates.crt"
          }

          image_pull_policy = "${var.image["pullPolicy"]}"
        }

        service_account_name = "cluster-autoscaler"
      }
    }
  }
}
