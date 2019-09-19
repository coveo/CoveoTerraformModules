resource "kubernetes_cluster_role" "cluster_autoscaler" {
  metadata {
    name = "cluster-autoscaler"
    labels {
      k8s-addon = "cluster-autoscaler.addons.k8s.io"
      k8s-app   = "cluster-autoscaler"
    }
  }

  rule {
    verbs      = ["create", "patch"]
    api_groups = [""]
    resources  = ["events", "endpoints"]
  }
  rule {
    verbs      = ["create"]
    api_groups = [""]
    resources  = ["pods/eviction"]
  }
  rule {
    verbs      = ["update"]
    api_groups = [""]
    resources  = ["pods/status"]
  }
  rule {
    verbs          = ["get", "update"]
    api_groups     = [""]
    resources      = ["endpoints"]
    resource_names = ["cluster-autoscaler"]
  }
  rule {
    verbs      = ["watch", "list", "get", "update"]
    api_groups = [""]
    resources  = ["nodes"]
  }
  rule {
    verbs      = ["watch", "list", "get"]
    api_groups = [""]
    resources  = ["pods", "services", "replicationcontrollers", "persistentvolumeclaims", "persistentvolumes"]
  }
  rule {
    verbs      = ["watch", "list", "get"]
    api_groups = ["extensions"]
    resources  = ["replicasets", "daemonsets"]
  }
  rule {
    verbs      = ["watch", "list"]
    api_groups = ["policy"]
    resources  = ["poddisruptionbudgets"]
  }
  rule {
    verbs      = ["watch", "list", "get"]
    api_groups = ["apps"]
    resources  = ["statefulsets", "replicasets", "daemonsets"]
  }
  rule {
    verbs      = ["watch", "list", "get"]
    api_groups = ["storage.k8s.io"]
    resources  = ["storageclasses"]
  }
  rule {
    verbs      = ["get", "list", "watch", "patch"]
    api_groups = ["batch", "extensions"]
    resources  = ["jobs"]
  }
}

resource "kubernetes_role" "cluster_autoscaler" {
  metadata {
    name      = "cluster-autoscaler"
    namespace = "${var.namespace}"
    labels {
      k8s-addon = "cluster-autoscaler.addons.k8s.io"
      k8s-app   = "cluster-autoscaler"
    }
  }
  rule {
    verbs      = ["create", "list", "watch"]
    api_groups = [""]
    resources  = ["configmaps"]
  }
  rule {
    verbs          = ["delete", "get", "update", "watch"]
    api_groups     = [""]
    resources      = ["configmaps"]
    resource_names = ["cluster-autoscaler-status", "cluster-autoscaler-priority-expander"]
  }
}

resource "kubernetes_cluster_role_binding" "cluster_autoscaler" {
  metadata {
    name = "cluster-autoscaler"
    labels {
      k8s-app   = "cluster-autoscaler"
      k8s-addon = "cluster-autoscaler.addons.k8s.io"
    }
  }

  subject {
    kind      = "ServiceAccount"
    name      = "cluster-autoscaler"
    namespace = "${var.namespace}"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-autoscaler"
  }
}

resource "kubernetes_role_binding" "cluster_autoscaler" {
  metadata {
    name      = "cluster-autoscaler"
    namespace = "${var.namespace}"

    labels {
      k8s-addon = "cluster-autoscaler.addons.k8s.io"
      k8s-app   = "cluster-autoscaler"
    }
  }
  subject {
    kind      = "ServiceAccount"
    name      = "cluster-autoscaler"
    namespace = "${var.namespace}"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "cluster-autoscaler"
  }
}


resource "kubernetes_service_account" "cluster_autoscaler" {
  metadata {
    name      = "cluster-autoscaler"
    namespace = "${var.namespace}"

    labels {
      k8s-app = "cluster-autoscaler"
      k8s-addon = "cluster-autoscaler.addons.k8s.io"
    }
  }
}
