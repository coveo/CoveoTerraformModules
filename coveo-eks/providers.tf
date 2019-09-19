data "aws_eks_cluster_auth" "cluster_auth" {
  name = "${var.cluster_name}"
}

provider "kubernetes" {
  version                = ">= 1.8.1"
  host                   = "${module.k8s-cluster.cluster_endpoint}"
  cluster_ca_certificate = "${base64decode(module.k8s-cluster.cluster_certificate_authority_data)}"
  token                  = "${data.aws_eks_cluster_auth.cluster_auth.token}"
  load_config_file       = false
}

provider "helm" {
  service_account = "${kubernetes_service_account.tiller.metadata.0.name}"
  install_tiller  = false
  namespace       = "kube-system"

  kubernetes {
    host                   = "${module.k8s-cluster.cluster_endpoint}"
    cluster_ca_certificate = "${base64decode(module.k8s-cluster.cluster_certificate_authority_data)}"
    token                  = "${data.aws_eks_cluster_auth.cluster_auth.token}"
    load_config_file       = false
  }
}
