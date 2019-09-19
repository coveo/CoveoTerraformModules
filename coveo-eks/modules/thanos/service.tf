resource "kubernetes_service" "thanos_querier" {
  count = "${var.deploy_querier ? 1 : 0}"

  metadata {
    name      = "thanos-querier"
    namespace = "${var.namespace}"

    labels {
      app = "thanos-querier"
    }
  }

  spec {
    port {
      name        = "http"
      protocol    = "TCP"
      port        = "${var.http_port}"
      target_port = "http"
    }

    selector {
      app = "thanos-querier"
    }

    type = "NodePort"
  }
}

# Enables stores to be exposed through r53-srvupdater
resource "kubernetes_service" "thanos_store" {
  count = "${var.deploy_store ? 1 : 0}"

  metadata {
    name      = "thanos-store"
    namespace = "${var.namespace}"
    labels {
      app = "thanos"
      thanos-api = "true"
    }
  }

  spec {
    port {
      name        = "grpc"
      protocol    = "TCP"
      port        = "${var.grpc_port}"
      target_port = "grpc"
    }
    selector {
      app = "thanos-store"
    }

    type = "NodePort"
  }
}

# Enables sidecar to be exposed through r53-srvupdater
resource "kubernetes_service" "sidecar" {
  count = 2
  metadata {
    name = "sidecar-${count.index}"
    namespace = "${var.namespace}"
    labels {
      app = "thanos"
      thanos-api = "true"
    }
  }
  spec {
    port {
      name        = "grpc"
      protocol    = "TCP"
      port        = "${var.grpc_port}"
      target_port = "grpc"
    }
    selector {
      "statefulset.kubernetes.io/pod-name" = "${var.sidecar_basename}-${count.index}"
    }
    type = "NodePort"
  }
}
