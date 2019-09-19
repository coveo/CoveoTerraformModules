resource "kubernetes_service" "cluster_autoscaler_prometheus_discovery" {
  metadata {
    name      = "cluster-autoscaler-prometheus-discovery"
    namespace = "${var.namespace}"

    labels {
      k8s-app = "cluster-autoscaler"
    }
  }

  spec {
    port {
      name        = "http"
      protocol    = "TCP"
      port        = 8085
      target_port = "8085"
    }

    selector {
      k8s-app = "cluster-autoscaler"
    }

    cluster_ip = "None"
    type       = "ClusterIP"
  }
}
