# Doc: https://goo.gl/U7FeFi
data "aws_iam_policy_document" "route53_exporter" {
  statement {
    actions = [
      "route53:ChangeResourceRecordSets",
      "route53:ListResourceRecordSets"
    ]
    resources = ["arn:aws:route53:::hostedzone/${var.domain_id}"]
  }
}

# Doc: https://goo.gl/U7FeFi
data "aws_iam_policy_document" "route53_exporter_assumerole" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "AWS"
      identifiers = ["${var.iam_assume_role_arn}"]
    }
  }
}

# Doc: https://goo.gl/57z0dQ
resource "aws_iam_role" "route53_exporter" {
  name_prefix        = "thanos-r53-exporter"
  assume_role_policy = "${data.aws_iam_policy_document.route53_exporter_assumerole.json}"
}

# Doc: https://goo.gl/BJIFiH
resource "aws_iam_role_policy" "route53_exporter" {
  name_prefix = "thanos-r53-exporter"
  role        = "${aws_iam_role.route53_exporter.name}"
  policy      = "${data.aws_iam_policy_document.route53_exporter.json}"
}

data "aws_iam_policy_document" "thanos_bucket" {
  statement {
    actions = [
      "s3:ListBucket",
      "s3:GetObject",
      "s3:DeleteObject",
      "s3:PutObject"
    ]

    resources = [
      "arn:aws:s3:::${local.bucket_name}/*",
      "arn:aws:s3:::${local.bucket_name}"
    ]
  }
}

# Doc: https://goo.gl/U7FeFi
data "aws_iam_policy_document" "thanos_bucket_assumerole" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "AWS"
      identifiers = ["${var.iam_assume_role_arn}"]
    }
  }
}

# Doc: https://goo.gl/57z0dQ
resource "aws_iam_role" "thanos_bucket" {
  name_prefix         = "thanos-bucket"
  assume_role_policy  = "${data.aws_iam_policy_document.thanos_bucket_assumerole.json}"
}

# Doc: https://goo.gl/BJIFiH
resource "aws_iam_role_policy" "thanos_bucket" {
  name_prefix = "thanos-bucket"
  role        = "${aws_iam_role.thanos_bucket.name}"
  policy      = "${data.aws_iam_policy_document.thanos_bucket.json}"
}
