resource "aws_iam_role" "cluster_autoscaler" {
  name_prefix        = "cluster-autoscaler"
  assume_role_policy = "${data.aws_iam_policy_document.assume_role_policy.json}"
}

resource "aws_iam_role_policy" "cluster_autoscaler" {
  name_prefix = "cluster-autoscaler"
  role        = "${aws_iam_role.cluster_autoscaler.name}"
  policy      = "${data.aws_iam_policy_document.role_policy.json}"
}

data "aws_iam_policy_document" "role_policy" {
  statement {
    actions = [
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeAutoScalingInstances",
      "autoscaling:DescribeTags",
      "autoscaling:DescribeLaunchConfigurations",
      "autoscaling:SetDesiredCapacity",
      "autoscaling:TerminateInstanceInAutoScalingGroup",
    ]

    resources = ["*"]
  }
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    principals {
      type        = "AWS"
      identifiers = ["${var.iam_assume_role_arn}"]
    }

    actions = ["sts:AssumeRole"]
  }
}
