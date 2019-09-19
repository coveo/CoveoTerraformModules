resource "kubernetes_cluster_role" "alb_ingress_controller" {
  metadata {
    name = "alb-ingress-controller"
    labels {
      app = "alb-ingress-controller"
    }
  }

  rule {
    verbs      = ["create", "get", "list", "update", "watch", "patch"]
    api_groups = ["", "extensions"]
    resources  = ["configmaps", "endpoints", "events", "ingresses", "ingresses/status", "services"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = ["", "extensions"]
    resources  = ["nodes", "pods", "secrets", "services", "namespaces"]
  }
}
