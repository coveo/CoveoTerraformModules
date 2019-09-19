resource "kubernetes_cluster_role_binding" "alb_ingress_controller" {
  metadata {
    name = "alb-ingress-controller"
    labels {
      app      = "alb-ingress-controller"
    }
  }

  subject {
    kind      = "ServiceAccount"
    name      = "alb-ingress-controller"
    namespace = "${var.namespace}"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "alb-ingress-controller"
  }
}
