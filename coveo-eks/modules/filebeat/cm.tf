data "template_file" "inputsconfig" {
  template = "${file("${path.module}/files/inputsconfig.yaml")}"

  vars {
    kube_system_log_enabled = "${var.kube_system_log_enabled}"
    kube_audit_log_enabled  = "${var.kube_audit_log_enabled}"
  }
}

resource "kubernetes_config_map" "inputsconfig" {
  metadata {
    name      = "inputsconfig"
    namespace = "${var.namespace}"

    labels {
      app        = "filebeat"
      prometheus = "filebeat"
    }
  }

  data {
    inputsconfig.yml = "${data.template_file.inputsconfig.rendered}"
  }
}
