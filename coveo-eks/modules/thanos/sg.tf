resource "aws_security_group_rule" "allow_dep_nodeport" {
  count             = "${var.create_dep_security_rule ? 1 : 0}"
  type              = "ingress"
  from_port         = "30000"
  to_port           = "32767"
  protocol          = "TCP"
  cidr_blocks       = ["${var.deployment_cidr}"]
  security_group_id = "${var.node_security_group}"
}
