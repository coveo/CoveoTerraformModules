data "template_file" "external_dns_values" {
  template = "${file("${path.module}/values.yaml")}"

  vars {
    zoneIdFilters = "${var.domain_id}"
    domainFilters = "${var.domain_name}"
    txtOwnerId    = "${var.cluster_name}"
    roleName      = "${aws_iam_role.externaldns_kubernetes.name}"
  }
}

resource "helm_release" "external_dns" {
  count     = "${var.helm_deployed ? 1 : 0}"
  name      = "external-dns"
  chart     = "stable/external-dns"
  namespace = "${var.namespace}"
  version   = "2.5.3"

  values = ["${data.template_file.external_dns_values.rendered}"]
}
