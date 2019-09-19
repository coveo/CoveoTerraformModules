resource "kubernetes_service_account" "r53_thanosupdater" {
  metadata {
    name      = "r53-thanosupdater"
    namespace = "${var.namespace}"
  }
}

resource "kubernetes_cluster_role_binding" "r53_thanosupdater" {
  metadata {
    name = "r53-thanosupdater"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "r53-thanosupdater"
    namespace = "${var.namespace}"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "r53-thanosupdater"
  }
}

resource "kubernetes_cluster_role" "r53_thanosupdater" {
  metadata {
    name = "r53-thanosupdater"
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = ["", "extensions"]
    resources  = ["services", "endpoints", "namespaces"]
  }
}
