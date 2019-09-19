resource "kubernetes_cluster_role_binding" "filebeat" {
  metadata {
    name = "filebeat"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "filebeat"
    namespace = "${var.namespace}"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "filebeat"
  }
}

resource "kubernetes_cluster_role" "filebeat" {
  metadata {
    name = "filebeat"
  }

  rule {
    verbs      = ["get", "watch", "list"]
    api_groups = ["*"]
    resources  = ["pods", "namespaces"]
  }
}

resource "kubernetes_service_account" "filebeat" {
  metadata {
    name      = "filebeat"
    namespace = "${var.namespace}"
  }
}
