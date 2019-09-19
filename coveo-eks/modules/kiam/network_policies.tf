resource "kubernetes_network_policy" "allow_kiam_server_port" {
  metadata {
    name      = "allow-kiam-server-port"
    namespace = "${var.namespace}"
  }

  spec {
    pod_selector {
      match_labels {
        app       = "kiam"
        component = "server"
      }
    }

    ingress {
      ports {
        protocol = "TCP"
        port     = "443"
      }
    }

    policy_types = ["Ingress"]
  }
}

resource "kubernetes_network_policy" "allow_kiam_monitoring" {
  metadata {
    name      = "allow-kiam-monitoring"
    namespace = "${var.namespace}"
  }

  spec {
    pod_selector {
      match_labels {
        app = "kiam"
      }
    }

    ingress {
      ports {
        protocol = "TCP"
        port     = "9620"
      }

      from {
        namespace_selector {
          match_labels {
            name = "monitoring"
          }
        }
      }

      from {
        pod_selector {
          match_labels {
            app = "prometheus"
          }
        }
      }
    }

    policy_types = ["Ingress"]
  }
}
