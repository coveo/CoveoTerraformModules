resource "null_resource" "ensure_kube_proxy" {
  depends_on = ["kubernetes_config_map.aws_auth_configmap"]

  provisioner "local-exec" {
    working_dir = "${path.module}"

    command = <<EOS
for i in `seq 1 10`; do \
echo "${null_resource.ensure_kube_proxy.triggers.kube_config_map_rendered}" > kube_config.yaml && \
kubectl set image -n kube-system ds/kube-proxy \
kube-proxy=${null_resource.ensure_kube_proxy.triggers.kube_proxy_image} \
--kubeconfig kube_config.yaml && \
echo "--- KUBEPROXY IS UP TO DATE ---" && break || \
sleep 10; \
done;
EOS

    interpreter = ["/bin/sh", "-c"]
  }

  triggers {
    kube_config_map_rendered = "${module.k8s-cluster.kubeconfig}"
    kube_proxy_image         = "602401143452.dkr.ecr.${var.region}.amazonaws.com/eks/kube-proxy:v${var.kube_proxy_version}"
  }
}
