data "template_file" "kiam_values" {
  template = "${file("${path.module}/values.yaml")}"

  vars {
    use_ubuntu_ami = "${var.use_ubuntu_ami}"
  }
}

resource "helm_release" "kiam" {
  count     = "${var.helm_deployed ? 1 : 0}"
  name      = "kiam"
  version   = "2.5.1"
  chart     = "stable/kiam"
  namespace = "${var.namespace}"

  values = ["${data.template_file.kiam_values.rendered}"]
}
