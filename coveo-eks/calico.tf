resource "null_resource" "deploy_calico" {
  depends_on = ["kubernetes_config_map.aws_auth_configmap"]

  provisioner "local-exec" {
    working_dir = "${path.module}"

    command = <<EOS
for i in `seq 1 10`; do \
echo "${null_resource.deploy_calico.triggers.kube_config_map_rendered}" > kube_config.yaml && \
kubectl apply -f ${var.calico_manifest_url} --kubeconfig kube_config.yaml && \
echo "--- CALICO IS UP TO DATE ---" && break || \
sleep 10; \
done;
EOS

    interpreter = ["/bin/sh", "-c"]
  }

  triggers {
    kube_config_map_rendered = "${module.k8s-cluster.kubeconfig}"
    calico_manifest_url      = "${var.calico_manifest_url}"
  }
}
