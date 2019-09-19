resource "kubernetes_network_policy" "allow_http_prometheus" {
  metadata {
    name      = "allow-http-prometheus"
    namespace = "${var.namespace}"
  }
  spec {
    pod_selector {
      match_labels {
        app         = "prometheus"
        prometheus  = "prometheus-operator-promet-prometheus"
      }
    }
    ingress {
      ports {
        protocol = "TCP"
        port     = "9090"
      }
    }
    policy_types = ["Ingress"]
  }
}

resource "kubernetes_network_policy" "allow_http_alertmanager" {
  metadata {
    name      = "allow-http-alertmanager"
    namespace = "${var.namespace}"
  }
  spec {
    pod_selector {
      match_labels {
        app         = "alertmanager"
        prometheus  = "prometheus-operator-promet-alertmanager"
      }
    }
    ingress {
      ports {
        protocol = "TCP"
        port     = "9093"
      }
    }
    policy_types = ["Ingress"]
  }
}

resource "kubernetes_network_policy" "allow_http_grafana" {
  count = "${var.enable_grafana ? 1 : 0}"
  
  metadata {
    name      = "allow-http-grafana"
    namespace = "${var.namespace}"
  }
  spec {
    pod_selector {
      match_labels {
        app         = "grafana"
      }
    }
    ingress {
      ports {
        protocol = "TCP"
        port     = "3000"
      }
    }
    policy_types = ["Ingress"]
  }
}

resource "kubernetes_network_policy" "allow_https_prometheus_adapter" {
  metadata {
    name      = "allow-https-prometheus-adapter"
    namespace = "${var.namespace}"
  }
  spec {
    pod_selector {
      match_labels {
        app         = "prometheus-adapter"
      }
    }
    ingress {
      ports {
        protocol = "TCP"
        port     = "6443"
      }
    }
    policy_types = ["Ingress"]
  }
}
