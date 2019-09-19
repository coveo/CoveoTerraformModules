resource "aws_s3_bucket" "thanos_bucket" {
  bucket  = "${local.bucket_name}"
  region  = "${var.default_region}"
  acl     = "private"
  count   = "${var.manage_bucket ? 1 : 0 }"

  tags = {
    Name        = "${local.bucket_name}"
    Environment = "${var.env}"
  }
}
