resource "aws_security_group" "monitoring" {
  name_prefix = "${var.prefix}-monitoring-alb-eks"
  description = "ALB sg for monitoring"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = "${var.allowed_monitoring_cidr}"
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
