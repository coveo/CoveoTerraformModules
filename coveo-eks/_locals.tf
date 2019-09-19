locals {
  kiam_worker_groups = [{
    name                  = "kiam"
    instance_type         = "t3.medium"
    key_name              = "${var.kiam_key_name}"
    desired_capacity      = "1"
    max_size              = "2"
    min_size              = "1"
    protect_from_scale_in = false
    autoscaling_enabled   = true
    kubelet_extra_args    = "--node-labels=kiam-server=true --register-with-taints=kiam-server=false:NoSchedule"
    iam_role_id           = "${aws_iam_role.kiam_workers.id}"

    pre_userdata = <<EOS
exec > >(tee /var/log/user-data.log|logger -t user-data ) 2>&1
${base64decode(var.infra_bootstrap_puppet_eks_ubuntu)}
EOS
  }]

  workers_group_defaults_overrides = {
    default = {}

    ubuntu = "${map("ami_id", data.aws_ami.ubuntu.image_id)}" // Here it imply that an ami for ubuntu is already available before creating an EKS cluster
  }

  worker_group_kiam_tags = {
    kiam = [{
      key                 = "hostname-prefix"
      value               = "${var.prefix}-eks"
      propagate_at_launch = true
    }]
  }
}
