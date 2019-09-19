resource "kubernetes_service_account" "auth_operator" {
  metadata {
    name      = "auth-operator"
    namespace = "${var.namespace}"
  }
}

resource "kubernetes_cluster_role" "auth_operator_role_cluster" {
  metadata {
    name = "auth-operator-role-cluster"
  }

  rule {
    verbs      = ["list", "watch", "patch", "get"]
    api_groups = ["zalando.org"]
    resources  = ["kopfpeerings", "clusterkopfpeerings"]
  }

  rule {
    verbs      = ["create"]
    api_groups = ["events.k8s.io"]
    resources  = ["events"]
  }

  rule {
    verbs      = ["create"]
    api_groups = [""]
    resources  = ["events"]
  }

  rule {
    verbs      = ["list", "watch", "patch", "get"]
    api_groups = ["iamauthenticator.k8s.aws"]
    resources  = ["iamidentitymappings"]
  }

  rule {
    verbs      = ["list", "watch", "patch", "get"]
    api_groups = [""]
    resources  = ["configmaps"]
  }

  rule {
    verbs      = ["list", "get"]
    api_groups = ["apiextensions.k8s.io"]
    resources  = ["customresourcedefinitions"]
  }
}

resource "kubernetes_cluster_role_binding" "auth_operator_rolebinding_cluster" {
  metadata {
    name = "auth-operator-rolebinding-cluster"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "auth-operator"
    namespace = "${var.namespace}"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "auth-operator-role-cluster"
  }
}
