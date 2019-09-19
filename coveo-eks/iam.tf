resource "aws_iam_role" "kiam_workers" {
  name_prefix           = "${var.cluster_name}-kiam"
  assume_role_policy    = "${data.aws_iam_policy_document.workers_assume_role_policy.json}"
  force_detach_policies = true
}

data "aws_iam_policy_document" "workers_assume_role_policy" {
  statement {
    sid = "EKSWorkerAssumeRole"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "bootstrap-reqs" {
  statement {
    actions = [
      "ec2:CreateTags",
      "ec2:DescribeTags",
    ]

    resources = [
      "*",
    ]
  }
}

data "aws_iam_policy_document" "ssm-agent-reqs" {
  statement {
    actions = [
      "ssm:UpdateInstanceInformation",
      "ssm:ListAssociations",
      "ssm:ListInstanceAssociations",
      "ec2messages:GetMessages",
      "ssmmessages:CreateControlChannel",
      "ssmmessages:CreateDataChannel",
      "ssmmessages:OpenControlChannel",
      "ssmmessages:OpenDataChannel",
    ]

    ## on pourrait peut-être cibler à des ressources plus précises.
    resources = [
      "*",
    ]
  }
}

resource "aws_iam_policy" "bootstrap-reqs" {
  name        = "${var.cluster_name}-pol-eks-bootstrap-reqs"
  description = "Puppet requirements for instance tags and hostname modifications"

  policy = "${data.aws_iam_policy_document.bootstrap-reqs.json}"
}

resource "aws_iam_policy" "ssm-agent-reqs" {
  name        = "${var.cluster_name}-pol-eks-ssm-agent-reqs"
  description = "SSM agent requirements"

  policy = "${data.aws_iam_policy_document.ssm-agent-reqs.json}"
}

resource "aws_iam_role_policy_attachment" "kiam_workers_AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = "${aws_iam_role.kiam_workers.name}"
}

resource "aws_iam_role_policy_attachment" "kiam_workers_AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = "${aws_iam_role.kiam_workers.name}"
}

resource "aws_iam_role_policy_attachment" "kiam_workers_AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = "${aws_iam_role.kiam_workers.name}"
}

resource "aws_iam_role_policy_attachment" "eks-bootstrap-reqs-kiam" {
  policy_arn = "${aws_iam_policy.bootstrap-reqs.arn}"
  role       = "${aws_iam_role.kiam_workers.name}"
}

resource "aws_iam_role_policy_attachment" "eks-ssm-agent-kiam" {
  policy_arn = "${aws_iam_policy.ssm-agent-reqs.arn}"
  role       = "${aws_iam_role.kiam_workers.name}"
}

resource "aws_iam_role_policy_attachment" "eks-bootstrap-reqs-workers" {
  policy_arn = "${aws_iam_policy.bootstrap-reqs.arn}"
  role       = "${module.k8s-cluster.worker_iam_role_name}"
}

resource "aws_iam_role_policy_attachment" "eks-ssm-agent-workers" {
  policy_arn = "${aws_iam_policy.ssm-agent-reqs.arn}"
  role       = "${module.k8s-cluster.worker_iam_role_name}"
}
