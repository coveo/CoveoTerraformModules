# Doc: https://goo.gl/U7FeFi
data "aws_iam_policy_document" "eks_alb_controller" {
  statement {
    actions = [
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:CreateSecurityGroup",
      "ec2:CreateTags",
      "ec2:DeleteSecurityGroup",
      "ec2:DescribeInstances",
      "ec2:DescribeInstanceStatus",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeSubnets",
      "ec2:DescribeTags",
      "ec2:DescribeVpcs",
      "ec2:ModifyInstanceAttribute",
      "ec2:RevokeSecurityGroupIngress",
      "elasticloadbalancing:AddTags",
      "elasticloadbalancing:CreateListener",
      "elasticloadbalancing:CreateLoadBalancer",
      "elasticloadbalancing:CreateRule",
      "elasticloadbalancing:CreateTargetGroup",
      "elasticloadbalancing:DeleteListener",
      "elasticloadbalancing:DeleteLoadBalancer",
      "elasticloadbalancing:DeleteRule",
      "elasticloadbalancing:DeleteTargetGroup",
      "elasticloadbalancing:DeregisterTargets",
      "elasticloadbalancing:DescribeListeners",
      "elasticloadbalancing:DescribeLoadBalancers",
      "elasticloadbalancing:DescribeLoadBalancerAttributes",
      "elasticloadbalancing:DescribeRules",
      "elasticloadbalancing:DescribeSSLPolicies",
      "elasticloadbalancing:DescribeTags",
      "elasticloadbalancing:DescribeTargetGroups",
      "elasticloadbalancing:DescribeTargetGroupAttributes",
      "elasticloadbalancing:DescribeTargetHealth",
      "elasticloadbalancing:ModifyListener",
      "elasticloadbalancing:ModifyLoadBalancerAttributes",
      "elasticloadbalancing:ModifyRule",
      "elasticloadbalancing:ModifyTargetGroup",
      "elasticloadbalancing:ModifyTargetGroupAttributes",
      "elasticloadbalancing:RegisterTargets",
      "elasticloadbalancing:RemoveTags",
      "elasticloadbalancing:SetIpAddressType",
      "elasticloadbalancing:SetSecurityGroups",
      "elasticloadbalancing:SetSubnets",
      "elasticloadbalancing:SetWebACL",
      "iam:GetServerCertificate",
      "iam:ListServerCertificates",
      "waf:GetWebACL",
      "waf-regional:GetWebACLForResource",
      "waf-regional:GetWebACL",
      "waf-regional:AssociateWebACL",
      "waf-regional:DisassociateWebACL",
      "tag:GetResources",
      "acm:ListCertificates",
    ]

    resources = ["*"]
  }
}

# Doc: https://goo.gl/U7FeFi
data "aws_iam_policy_document" "eks_alb_controller_assume" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    principals {
      type        = "AWS"
      identifiers = ["${var.iam_assume_role_arn}"]
    }
  }
}

# Doc: https://goo.gl/57z0dQ
resource "aws_iam_role" "eks_alb_controller" {
  name_prefix        = "eks-alb-controller"
  assume_role_policy = "${data.aws_iam_policy_document.eks_alb_controller_assume.json}"
}

# Doc: https://goo.gl/BJIFiH
resource "aws_iam_role_policy" "eks_alb_controller" {
  name_prefix = "eks-alb-controller"
  role        = "${aws_iam_role.eks_alb_controller.name}"
  policy      = "${data.aws_iam_policy_document.eks_alb_controller.json}"
}
