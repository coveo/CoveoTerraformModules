resource "kubernetes_config_map" "aws_auth_configmap" {
  depends_on = ["aws_security_group_rule.eks_ingress_coveo"]

  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data {
    mapRoles = <<YAML
- rolearn: ${module.k8s-cluster.worker_iam_role_arn}
  username: system:node:{{EC2PrivateDNSName}}
  groups:
    - system:bootstrappers
    - system:nodes
- rolearn: ${aws_iam_role.kiam_workers.arn}
  username: system:node:{{EC2PrivateDNSName}}
  groups:
    - system:bootstrappers
    - system:nodes
- rolearn: arn:aws:iam::${var.account_id}:role/user-role-ops-specialist
  username: kubectl-access-user
  groups:
    - system:masters
- rolearn: arn:aws:iam::${var.account_id}:role/user-role-infra
  username: kubectl-access-user-infra
  groups:
    - system:masters
YAML
  }

  lifecycle {
    ignore_changes = [
      "data.mapUsers",
    ]
  }
}
