resource "kubernetes_service_account" "alb_ingress_controller" {
  metadata {
    name      = "alb-ingress-controller"
    namespace = "${var.namespace}"

    labels {
      app      = "alb-ingress-controller"
    }
  }
}
