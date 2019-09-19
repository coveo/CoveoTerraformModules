resource "kubernetes_service_account" "tiller" {
  depends_on = ["kubernetes_config_map.aws_auth_configmap"]

  metadata {
    name      = "tiller"
    namespace = "kube-system"
  }
}

resource "kubernetes_cluster_role_binding" "tiller" {
  depends_on = ["kubernetes_config_map.aws_auth_configmap"]

  metadata {
    name = "tiller"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "tiller"
    namespace = "kube-system"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
}

resource "null_resource" "deploy_tiller" {
  depends_on = ["kubernetes_cluster_role_binding.tiller"]

  provisioner "local-exec" {
    working_dir = "${path.module}"

    command = <<EOS
for i in `seq 1 10`; do \
echo "${null_resource.deploy_tiller.triggers.kube_config_map_rendered}" > kube_config.yaml && \
helm init --service-account ${null_resource.deploy_tiller.triggers.tiller_svc_account} --kubeconfig kube_config.yaml && break || \
sleep 10; \
done;
EOS

    interpreter = ["/bin/sh", "-c"]
  }

  triggers {
    kube_config_map_rendered = "${module.k8s-cluster.kubeconfig}"
    tiller_svc_account       = "${kubernetes_service_account.tiller.metadata.0.name}"
  }
}

resource "null_resource" "helm_update" {
  depends_on = ["null_resource.deploy_tiller"]

  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = "helm repo update"
  }
}
