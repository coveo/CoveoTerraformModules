resource "kubernetes_network_policy" "allow_http_thanos_querier" {
  count = "${var.deploy_querier ? 1 : 0}"

  metadata {
    name      = "allow-http-thanos-querier"
    namespace = "${var.namespace}"
  }
  spec {
    pod_selector {
      match_labels {
        app         = "thanos-querier"
      }
    }
    ingress {
      ports {
        protocol = "TCP"
        port     = "http"
      }
    }
    policy_types = ["Ingress"]
  }
}

resource "kubernetes_network_policy" "allow_grpc_thanos" {
  metadata {
    name      = "allow-grpc-thanos-store"
    namespace = "${var.namespace}"
  }
  spec {
    pod_selector {
      match_labels {
        thanos-grpc = "true"
      }
    }
    ingress {
      ports {
        protocol = "TCP"
        port     = "grpc"
      }
    }
    policy_types = ["Ingress"]
  }
}
