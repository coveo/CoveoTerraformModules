resource "aws_iam_role" "externaldns_kubernetes" {
  name_prefix        = "${var.cluster_name}-externaldns"
  assume_role_policy = "${data.aws_iam_policy_document.assume_role_policy.json}"
}

resource "aws_iam_role_policy" "externaldns_kubernetes" {
  name_prefix = "${var.cluster_name}-externaldns"
  role        = "${aws_iam_role.externaldns_kubernetes.name}"
  policy      = "${data.aws_iam_policy_document.role_policy.json}"
}

data "aws_iam_policy_document" "role_policy" {
  statement {
    actions = [
      "route53:ListHostedZones",
      "route53:ListResourceRecordSets",
    ]

    resources = ["*"]
  }

  statement {
    actions = [
      "route53:ChangeResourceRecordSets",
    ]

    resources = ["arn:aws:route53:::hostedzone/${var.domain_id}"]
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
