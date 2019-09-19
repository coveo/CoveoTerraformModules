resource "null_resource" "ensure_coredns" {
  depends_on = ["kubernetes_config_map.aws_auth_configmap"]

  provisioner "local-exec" {
    working_dir = "${path.module}"

    command = <<EOS
for i in `seq 1 10`; do \
echo "${null_resource.ensure_coredns.triggers.kube_config_map_rendered}" > kube_config.yaml & \
kubectl set image -n kube-system deployment.apps/coredns \
coredns=${null_resource.ensure_coredns.triggers.coredns_version} \
--kubeconfig kube_config.yaml && \
echo "--- COREDNS IS UP TO DATE ---" && break || \
sleep 10; \
done;
EOS

    interpreter = ["/bin/sh", "-c"]
  }

  triggers {
    kube_config_map_rendered = "${module.k8s-cluster.kubeconfig}"
    coredns_version          = "602401143452.dkr.ecr.${var.region}.amazonaws.com/eks/coredns:v${var.coredns_version}"
  }
}
