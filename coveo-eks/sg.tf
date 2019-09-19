# Allow SSH on nodes
resource "aws_security_group_rule" "workers_ingress_ssh" {
  description       = "Allow ssh for OPS."
  protocol          = "tcp"
  security_group_id = "${module.k8s-cluster.worker_security_group_id}"
  from_port         = 22
  to_port           = 22
  cidr_blocks       = ["${var.infra_coveo_vpn_subnet_admin}"]
  type              = "ingress"
}

# Allow access to kubeapi from coveo
resource "aws_security_group_rule" "eks_ingress_coveo" {
  description       = "Allow access to kubeapi from VPN."
  protocol          = "tcp"
  security_group_id = "${module.k8s-cluster.cluster_security_group_id}"
  from_port         = 443
  to_port           = 443
  cidr_blocks       = ["${var.infra_coveo_vpn_subnet}"]
  type              = "ingress"
}

resource "aws_security_group_rule" "eks_ingress_contro_panel" {
  description       = "Allow access to node from kubeapi."
  protocol          = "tcp"
  security_group_id = "${module.k8s-cluster.worker_security_group_id}"
  from_port         = 0
  to_port           = 65535
  source_security_group_id  = "${module.k8s-cluster.cluster_security_group_id}"
  type              = "ingress"
}

resource "aws_security_group_rule" "coveo_ingress_nodeport" {
  description       = "Allow acces to NodePort for developers and ops."
  protocol          = "tcp"
  security_group_id = "${module.k8s-cluster.worker_security_group_id}"
  from_port         = 30000
  to_port           = 32767
  cidr_blocks       = ["${var.infra_coveo_vpn_subnet}", "${var.infra_vpc_cidr}"]
  type              = "ingress"
}

resource "aws_security_group_rule" "alb_ingress_nodeport" {
  description               = "Allow acces to NodePort from ALB."
  protocol                  = "tcp"
  security_group_id         = "${module.k8s-cluster.worker_security_group_id}"
  source_security_group_id  = "${var.infra_sg_k8s_elb}"
  from_port                 = 30000
  to_port                   = 32767
  type                      = "ingress"
}
