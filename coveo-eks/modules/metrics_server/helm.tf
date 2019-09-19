data "template_file" "metrics_server_values" {
  template = "${file("${path.module}/files/values_metrics_server.yaml")}"
}

resource "helm_release" "metrics_server" {
  count     = "${var.helm_deployed ? 1 : 0}"
  name      = "metrics-server"
  chart     = "stable/metrics-server"
  namespace = "${var.namespace}"

  values = ["${data.template_file.metrics_server_values.rendered}"]
}
