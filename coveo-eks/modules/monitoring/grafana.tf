# Doc: https://goo.gl/8G33Qp
resource "kubernetes_secret" "grafana_credentials" {
  count = "${var.enable_grafana ? 1 : 0}"

  metadata {
    name      = "grafana-credentials"
    namespace = "${var.namespace}"
  }

  type = "Opaque"

  data {
    "admin-user"      = "${aws_ssm_parameter.grafana_username.value}"
    "admin-password"  = "${quantum_password.grafana_password.password}"
  }
}

data "template_file" "grafana_node_dashboards" {
  template = "${file("${path.module}/files/grafana-dashboards/node-dashboard.json")}"

  vars {
    domain        = "${var.infra_domain_name}"
    DS_PROMETHEUS = "$${DS_PROMETHEUS}"
  }
}

data "template_file" "grafana_cluster_dashboards" {
  template = "${file("${path.module}/files/grafana-dashboards/k8s-cluster-dashboard.json")}"

  vars {
    alertmanager_url = "https://alertmanager.${var.infra_domain_name}/#/alerts"
    DS_PROMETHEUS    = "$${DS_PROMETHEUS}"
  }
}

data "template_file" "rabbitmq_dashboard" {
  template = "${file("${path.module}/files/grafana-dashboards/rabbitmq-dashboard.json")}"

  vars {
    DS_PROMETHEUS = "$${DS_PROMETHEUS}"
    rabbit_url    = "http://queueserver.${var.infra_domain_name}:15672/"
  }
}

data "template_file" "rabbitmq_queues_dashboard" {
  template = "${file("${path.module}/files/grafana-dashboards/rabbitmq-queues-dashboard.json")}"

  vars {
    DS_PROMETHEUS = "$${DS_PROMETHEUS}"
    rabbit_url    = "http://queueserver.${var.infra_domain_name}:15672/"
  }
}

resource "kubernetes_config_map" "grafana_dashboards_1" {
  count = "${var.enable_grafana ? 1 : 0}"

  metadata {
    name                  = "grafana-dashboards-1"
    namespace             = "${var.namespace}"
    labels {
      grafana_dashboard   = "1"
    }
  }

  ####### This CM is full use the below one #######
  data {
    daemonset-dashboard.json        = "${file("${path.module}/files/grafana-dashboards/daemonset-dashboard.json")}"
    deployment-dashboard.json       = "${file("${path.module}/files/grafana-dashboards/deployment-dashboard.json")}"
    dns-performances-dashboard.json = "${file("${path.module}/files/grafana-dashboards/dns-performances.json")}"
    kiam-dashboard.json             = "${file("${path.module}/files/grafana-dashboards/kiam-dashboard.json")}"
    logging-logstash-dashboard.json = "${file("${path.module}/files/grafana-dashboards/logging-logstash.json")}"
    logging-redis-dashboard.json    = "${file("${path.module}/files/grafana-dashboards/logging-redis.json")}"
    nodes-full-dashboard.json       = "${file("${path.module}/files/grafana-dashboards/nodes-full-dashboard.json")}"
    node-dashboard.json             = "${data.template_file.grafana_node_dashboards.rendered}"
    pods-dashboard.json             = "${file("${path.module}/files/grafana-dashboards/pods-dashboard.json")}"
    statefulset-dashboard.json      = "${file("${path.module}/files/grafana-dashboards/statefulset-dashboard.json")}"
    ua-dashboard.json               = "${file("${path.module}/files/grafana-dashboards/ua-dashboard.json")}"
    sss-dashboard.json              = "${file("${path.module}/files/grafana-dashboards/sss-dashboard.json")}"
  }
}

resource "kubernetes_config_map" "grafana_dashboards_2" {
  count = "${var.enable_grafana ? 1 : 0}"

  metadata {
    name                  = "grafana-dashboards-2"
    namespace             = "${var.namespace}"
    labels {
      grafana_dashboard   = "1"
    }
  }

  data {
    etcd-dashboard.json                 = "${file("${path.module}/files/grafana-dashboards/etcd-dashboard.json")}"
    k8s-cluster-dashboard.json          = "${data.template_file.grafana_cluster_dashboards.rendered}"
    prometheus2-overview-dashboard.json = "${file("${path.module}/files/grafana-dashboards/prometheus2-overview-dashboard.json")}"
    qts-overview-dashboard.json         = "${file("${path.module}/files/grafana-dashboards/qts-overview-dashboard.json")}"
    rabbitmq-queues-dashboard.json      = "${data.template_file.rabbitmq_queues_dashboard.rendered}"
    rabbitmq-dashboard.json             = "${data.template_file.rabbitmq_dashboard.rendered}"
    sentry-dashboard.json               = "${file("${path.module}/files/grafana-dashboards/sentry-dashboard.json")}"
    ops-alerts-dashboard.json           = "${file("${path.module}/files/grafana-dashboards/ops-alerts-dashboard.json")}"
    alerts-products-dashboard.json      = "${file("${path.module}/files/grafana-dashboards/alerts-products-dashboard.json")}"
  }
}

resource "kubernetes_config_map" "grafana_datasources_1" {
  count = "${var.enable_grafana ? 1 : 0}"

  metadata {
    name                  = "grafana-datasources-1"
    namespace             = "${var.namespace}"
    labels {
      grafana_datasource  = "1"
    }
  }

  data {
    alertmanager-datasource.yaml    = "${file("${path.module}/files/grafana-dashboards/alertmanager-datasource.yaml")}"
    thanos.yaml                     = "${file("${path.module}/files/grafana-dashboards/thanos.yaml")}"
  }
}

resource "kubernetes_config_map" "grafana_dashboards_extra" {
  count = "${var.is_default_region && var.env == "dev" && var.enable_grafana ? 1 : 0}"

  metadata {
    name                  = "grafana-dashboards-extra"
    namespace             = "${var.namespace}"
    labels {
      grafana_dashboard   = "1"
    }
  }

  data {
    # Only if var.is_default_region && var.env == "dev"
    products-versions-dashboard.json    = "${file("${path.module}/files/grafana-dashboards/products-versions-dashboard.json")}"
  }
}

resource "kubernetes_config_map" "grafana_datasources_extra" {
  count = "${var.is_default_region && var.env == "dev" && var.enable_grafana ? 1 : 0}"
  
  metadata {
    name                  = "grafana-datasources-extra"
    namespace             = "${var.namespace}"
    labels {
      grafana_datasource  = "1"
    }
  }

  data {
    # Only if var.is_default_region && var.env == "dev"
    grafana-simple-json-datasource.yaml = "${file("${path.module}/files/grafana-dashboards/grafana-simple-json-datasource.yaml")}"
  }
}
