resource "kubernetes_namespace" "infrastructure" {
  depends_on = ["kubernetes_config_map.aws_auth_configmap"]

  metadata {
    annotations = {
      "iam.amazonaws.com/permitted" = ".*"
    }

    labels = {
      name = "infrastructure"
    }

    name = "infrastructure"
  }
}

resource "kubernetes_namespace" "ingress" {
  depends_on = ["kubernetes_config_map.aws_auth_configmap"]

  metadata {
    annotations = {
      "iam.amazonaws.com/permitted" = ".*"
    }

    labels = {
      name = "ingress"
    }

    name = "ingress"
  }
}

resource "kubernetes_namespace" "monitoring" {
  depends_on = ["kubernetes_config_map.aws_auth_configmap"]

  metadata {
    annotations = {
      "iam.amazonaws.com/permitted" = ".*"
    }

    labels = {
      name = "monitoring"
    }

    name = "monitoring"
  }
}

resource "kubernetes_namespace" "csec" {
  depends_on = ["kubernetes_config_map.aws_auth_configmap"]

  metadata {
    annotations = {
      "iam.amazonaws.com/permitted" = ".*"
    }

    labels = {
      name = "csec"
    }

    name = "csec"
  }
}

resource "kubernetes_namespace" "ns" {
  depends_on = ["kubernetes_config_map.aws_auth_configmap"]
  count      = "${length(var.namespaces)}"

  metadata {
    annotations = {
      "iam.amazonaws.com/permitted" = ".*"
    }

    labels = {
      name = "${element(var.namespaces,count.index)}"
    }

    name = "${element(var.namespaces,count.index)}"
  }
}
