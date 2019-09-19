resource "null_resource" "retrieve_aws_cni" {
  depends_on = ["kubernetes_config_map.aws_auth_configmap"]

  provisioner "local-exec" {
    working_dir = "${path.module}"

    command = <<EOS
for i in `seq 1 10`; do \
echo "${null_resource.retrieve_aws_cni.triggers.kube_config_map_rendered}" > kube_config.yaml && \
kubectl apply -f ${null_resource.retrieve_aws_cni.triggers.cni_manifest_url} --kubeconfig kube_config.yaml && \
echo "--- AWS CNI IS UP TO DATE ---" && break || \
sleep 10; \
done;
EOS

    interpreter = ["/bin/sh", "-c"]
  }

  triggers {
    kube_config_map_rendered = "${module.k8s-cluster.kubeconfig}"
    cni_manifest_url         = "https://raw.githubusercontent.com/aws/amazon-vpc-cni-k8s/release-${var.cni_version}/config/v${var.cni_version}/aws-k8s-cni.yaml"
  }
}
