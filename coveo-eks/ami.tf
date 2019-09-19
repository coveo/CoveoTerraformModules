data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["eks18-*"]
  }

  filter {
    name   = "tag:Os"
    values = ["Ubuntu 18"]
  }

  filter {
    name   = "tag:env"
    values = ["${var.env}"]
  }

  owners = ["self"]
}
