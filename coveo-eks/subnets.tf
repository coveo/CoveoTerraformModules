data "aws_subnet" "containers_subnets" {
  count = "${length(var.clusters_subnets)}"
  id    = "${var.clusters_subnets[count.index]}"
}

// Subnet are handle in an other module so we need to do a null resource to tag subnet with aws cli.
resource "null_resource" "containers_subnets_tag_update" {
  count = "${length(var.clusters_subnets)}"

  triggers = {
    # jsonencode() is used because trigger values need to be strings
    tags = "${jsonencode(data.aws_subnet.containers_subnets.*.tags[count.index])}"
  }

  provisioner "local-exec" {
    command = <<EOF
      aws --region ${var.region_id} ec2 create-tags \
      --resources ${data.aws_subnet.containers_subnets.*.id[count.index]} \
      --tags "Key=kubernetes.io/cluster/${var.cluster_name},Value=shared"
    EOF
  }
}
