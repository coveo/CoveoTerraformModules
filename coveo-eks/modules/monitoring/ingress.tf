resource "kubernetes_ingress" "prometheus" {
  metadata {
    name = "prometheus"
    namespace = "${var.namespace}"
    labels {
      prometheus = "prometheus2"
      app = "prometheus"
    }
    annotations {
      "external-dns.alpha.kubernetes.io/hostname" = "${local.prometheus_url}"
      "kubernetes.io/ingress.class" = "alb"
      "alb.ingress.kubernetes.io/scheme" = "internal"
      "alb.ingress.kubernetes.io/security-groups" = "${aws_security_group.monitoring.id}"
      "alb.ingress.kubernetes.io/certificate-arn" = "${var.infra_server_certificate_star_env_arn}"
      "alb.ingress.kubernetes.io/listen-ports" = "[{\"HTTPS\": 443}]"
      "alb.ingress.kubernetes.io/healthcheck-path" = "/-/healthy"
      "alb.ingress.kubernetes.io/tags" = "coveo:billing=infra__mt__${var.namespace}"
    }
  }
  spec {
    rule {
      host = "${local.prometheus_url}"
      http {
        path {
          path = "/*"
          backend {
            service_name = "prometheus-operator-promet-prometheus"
            service_port = "9090"
          }
        }
      }
    }
  }
}

resource "kubernetes_ingress" "alertmanager" {
  metadata {
    name = "alertmanager"
    namespace = "${var.namespace}"
    labels {
      alertmanager = "prometheus-operator-promet-alertmanager"
      app = "alertmanager"
    }
    annotations {
      "external-dns.alpha.kubernetes.io/hostname" = "${local.alertmanager_url}"
      "kubernetes.io/ingress.class" = "alb"
      "alb.ingress.kubernetes.io/scheme" = "internal"
      "alb.ingress.kubernetes.io/security-groups" = "${aws_security_group.monitoring.id}"
      "alb.ingress.kubernetes.io/certificate-arn" = "${var.infra_server_certificate_star_env_arn}"
      "alb.ingress.kubernetes.io/listen-ports" = "[{\"HTTPS\": 443}]"
      "alb.ingress.kubernetes.io/healthcheck-path" = "/-/healthy"
      "alb.ingress.kubernetes.io/tags" = "coveo:billing=infra__mt__${var.namespace}"
    }
  }
  spec {
    rule {
      host = "${local.alertmanager_url}"
      http {
        path {
          path = "/*"
          backend {
            service_name = "prometheus-operator-promet-alertmanager"
            service_port = "9093"
          }
        }
      }
    }
  }
}

resource "kubernetes_ingress" "grafana" {
  count = "${var.enable_grafana ? 1 : 0}" 

  metadata {
    name = "grafana"
    namespace = "${var.namespace}"
    labels {
      app = "grafana"
    }
    annotations {
      "external-dns.alpha.kubernetes.io/hostname" = "${local.grafana_url}"
      "kubernetes.io/ingress.class" = "alb"
      "alb.ingress.kubernetes.io/scheme" = "internal"
      "alb.ingress.kubernetes.io/security-groups" = "${aws_security_group.monitoring.id}"
      "alb.ingress.kubernetes.io/certificate-arn" = "${var.infra_server_certificate_star_env_arn}"
      "alb.ingress.kubernetes.io/listen-ports" = "[{\"HTTPS\": 443}]"
      "alb.ingress.kubernetes.io/tags" = "coveo:billing=infra__mt__${var.namespace}"
      "alb.ingress.kubernetes.io/healthcheck-path" = "/api/health"
      "alb.ingress.kubernetes.io/target-group-attributes" = "stickiness.enabled=true,stickiness.lb_cookie.duration_seconds=600"
    }
  }
  spec {
    rule {
      host = "${local.grafana_url}"
      http {
        path {
          path = "/*"
          backend {
            service_name = "prometheus-operator-grafana"
            service_port = "80"
          }
        }
      }
    }
  }
}
