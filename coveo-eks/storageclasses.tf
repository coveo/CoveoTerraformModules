resource "kubernetes_storage_class" "gp2_encrypted_delete" {
  depends_on = ["kubernetes_config_map.aws_auth_configmap"]

  metadata {
    name = "gp2-encrypted-delete"
  }

  storage_provisioner = "kubernetes.io/aws-ebs"
  reclaim_policy      = "Delete"
  volume_binding_mode = "WaitForFirstConsumer"

  parameters = {
    type      = "gp2"
    encrypted = true
  }
}

resource "kubernetes_storage_class" "gp2_encrypted_retained_xfs" {
  depends_on = ["kubernetes_config_map.aws_auth_configmap"]

  metadata {
    name = "gp2-encrypted-retained-xfs"
  }

  storage_provisioner = "kubernetes.io/aws-ebs"
  reclaim_policy      = "Retain"
  volume_binding_mode = "WaitForFirstConsumer"

  parameters = {
    type      = "gp2"
    encrypted = true
    fsType    = "xfs"
  }
}

resource "kubernetes_storage_class" "gp2_encrypted_retained" {
  depends_on = ["kubernetes_config_map.aws_auth_configmap"]

  metadata {
    name = "gp2-encrypted-retained"
  }

  storage_provisioner = "kubernetes.io/aws-ebs"
  reclaim_policy      = "Retain"
  volume_binding_mode = "WaitForFirstConsumer"

  parameters = {
    type      = "gp2"
    encrypted = true
  }
}
