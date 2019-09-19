resource "kubernetes_deployment" "auth_operator" {
  metadata {
    name      = "auth-operator"
    namespace = "${var.namespace}"

    labels {
      app = "auth-operator"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels {
        app = "auth-operator"
      }
    }

    template {
      metadata {
        namespace = "${var.namespace}"

        labels {
          app = "auth-operator"
        }
      }

      spec {
        container {
          name  = "operator"
          image = "${var.image["repository"]}:${var.image["tag"]}"

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

          image_pull_policy = "${var.image["pull_policy"]}"
        }

        service_account_name = "${kubernetes_service_account.auth_operator.metadata.0.name}"
        automount_service_account_token = true
      }
    }

    strategy {
      type = "Recreate"
    }
  }
}
