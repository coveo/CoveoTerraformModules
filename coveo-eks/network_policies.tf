resource "kubernetes_network_policy" "default_deny_infrastructure" {
  metadata {
    name      = "deny-all"
    namespace = "${kubernetes_namespace.infrastructure.metadata.0.name}"
  }

  spec {
    pod_selector {
      match_labels {}
    }

    ingress {
      from {
        pod_selector {}
      }
    }

    policy_types = ["Ingress"]
  }
}

resource "kubernetes_network_policy" "default_deny_ingress" {
  metadata {
    name      = "deny-all"
    namespace = "${kubernetes_namespace.ingress.metadata.0.name}"
  }

  spec {
    pod_selector {
      match_labels {}
    }

    ingress {
      from {
        pod_selector {}
      }
    }

    policy_types = ["Ingress"]
  }
}

resource "kubernetes_network_policy" "default_deny_monitoring" {
  metadata {
    name      = "deny-all"
    namespace = "${kubernetes_namespace.monitoring.metadata.0.name}"
  }

  spec {
    pod_selector {
      match_labels {}
    }

    ingress {
      from {
        pod_selector {}
      }
    }

    policy_types = ["Ingress"]
  }
}

resource "kubernetes_network_policy" "default_deny_csec" {
  metadata {
    name      = "deny-all"
    namespace = "${kubernetes_namespace.csec.metadata.0.name}"
  }

  spec {
    pod_selector {
      match_labels {}
    }

    ingress {
      from {
        pod_selector {}
      }
    }

    policy_types = ["Ingress"]
  }
}

resource "kubernetes_network_policy" "default_deny" {
  depends_on = ["kubernetes_config_map.aws_auth_configmap"]
  count      = "${length(var.namespaces)}"

  metadata {
    name      = "deny-all"
    namespace = "${element(var.namespaces,count.index)}"
  }

  spec {
    pod_selector {
      match_labels {}
    }

    ingress {
      from {
        pod_selector {}
      }
    }

    policy_types = ["Ingress"]
  }
}
