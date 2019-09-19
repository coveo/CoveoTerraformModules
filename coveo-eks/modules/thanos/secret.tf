data "template_file" "secret_thanos" {
  template = "${file("${path.module}/files/thanos.yaml")}"

  vars = {
    bucket_name = "${local.bucket_name}"
    region      = "${var.default_region}"
  }
}

resource "kubernetes_secret" "secret_thanos" {
  metadata {
    name      = "thanos"
    namespace = "${var.namespace}"

    labels {
      app        = "thanos"
    }
  }

  type = "Opaque"

  data {
    thanos.yaml = "${data.template_file.secret_thanos.rendered}"
  }
}
