module "k8s-cluster" {
  source                          = "terraform-aws-modules/eks/aws"
  version                         = "4.0.2"
  cluster_name                    = "${var.cluster_name}"
  cluster_version                 = "${var.cluster_version}"
  cluster_enabled_log_types       = "${var.cluster_enabled_log_types}"
  cluster_endpoint_public_access  = false
  cluster_endpoint_private_access = true
  subnets                         = "${var.clusters_subnets}"
  vpc_id                          = "${var.vpc_id}"
  manage_aws_auth                 = false
  write_kubeconfig                = false
  write_aws_auth_config           = false
  worker_groups                   = "${concat(local.kiam_worker_groups, var.worker_groups)}"
  worker_group_count              = "${1 + length(var.worker_groups)}"                                                    // We cannot use interpolation in count variable so here is a quick trick to add kiam asg to the worker list
  worker_group_tags               = "${merge(local.worker_group_kiam_tags, var.worker_group_tags)}"
  workers_group_defaults          = "${local.workers_group_defaults_overrides[var.use_ubuntu_ami ? "ubuntu": "default"]}"

  tags = "${var.tags}"
}

module "external_dns" {
  source              = "./modules/external_dns"
  namespace           = "${kubernetes_namespace.infrastructure.metadata.0.name}"
  helm_deployed       = "${kubernetes_service_account.tiller.metadata.0.name == "tiller"}"
  domain_id           = "${var.domain_id}"
  domain_name         = "${var.domain_name}"
  cluster_name        = "${module.k8s-cluster.cluster_id}"
  iam_assume_role_arn = "${aws_iam_role.kiam_workers.arn}"
}

module "filebeat" {
  source                    = "./modules/filebeat"
  namespace                 = "${kubernetes_namespace.infrastructure.metadata.0.name}"
  cluster_name              = "${module.k8s-cluster.cluster_id}"
  elasticsearch_cluster_url = "${var.elasticsearch_cluster_url}"
  filebeat_deploy_resources = "${var.filebeat_deploy_resources}"
  redis_logs_endpoint       = "${var.redis_logs_endpoint}"
}

module "kiam" {
  namespace      = "${kubernetes_namespace.infrastructure.metadata.0.name}"
  helm_deployed  = "${kubernetes_service_account.tiller.metadata.0.name == "tiller"}"
  source         = "./modules/kiam"
  use_ubuntu_ami = "${var.use_ubuntu_ami}"
}

module "ingress_controller" {
  source              = "./modules/ingress_controller"
  namespace           = "${kubernetes_namespace.infrastructure.metadata.0.name}"
  cluster_name        = "${module.k8s-cluster.cluster_id}"
  iam_assume_role_arn = "${aws_iam_role.kiam_workers.arn}"
  vpc_id              = "${var.vpc_id}"
  region_id           = "${var.region_id}"
}

module "autoscaler" {
  source                           = "./modules/autoscaler"
  namespace                        = "${kubernetes_namespace.infrastructure.metadata.0.name}"
  iam_assume_role_arn              = "${aws_iam_role.kiam_workers.arn}"
  cluster_name                     = "${module.k8s-cluster.cluster_id}"
  scale_down_utilization_threshold = "${var.scale_down_utilization_threshold}"
}

module "thanos" {
  source                   = "./modules/thanos"
  namespace                = "${kubernetes_namespace.monitoring.metadata.0.name}"
  cluster_name             = "${module.k8s-cluster.cluster_id}"
  iam_assume_role_arn      = "${aws_iam_role.kiam_workers.arn}"
  domain_id                = "${var.domain_id}"
  domain_name              = "${var.domain_name}"
  region_id                = "${var.region_id}"
  thanos_image             = "${var.thanos_image}"
  thanos_version           = "${var.thanos_version}"
  manage_bucket            = "${var.thanos_manage_bucket}"
  deploy_querier           = "${var.thanos_deploy_querier}"
  deploy_store             = "${var.thanos_deploy_store}"
  retention_resolution_raw = "${var.thanos_retention_resolution_raw}"
  retention_resolution_5m  = "${var.thanos_retention_resolution_5m}"
  retention_resolution_1h  = "${var.thanos_retention_resolution_1h}"
  node_security_group      = "${module.k8s-cluster.worker_security_group_id}"
}

module "monitoring" {
  source                      = "./modules/monitoring"
  helm_deployed               = "${kubernetes_service_account.tiller.metadata.0.name == "tiller"}"
  namespace                   = "${kubernetes_namespace.monitoring.metadata.0.name}"
  cluster_name                = "${module.k8s-cluster.cluster_id}"
  prometheus_deploy_resources = "${var.prometheus_deploy_resources}"
  prometheus_retention        = "${var.prometheus_retention}"
  allowed_monitoring_cidr     = "${var.allowed_monitoring_cidr}"
  vpc_id                      = "${var.infra_vpc_id}"
  thanos_secret_name          = "${module.thanos.secret_name}"
  thanos_secret_version       = "${module.thanos.secret_version}"
  thanos_image                = "${var.thanos_image}"
  thanos_version              = "${var.thanos_version}"
  thanos_iam_role             = "${module.thanos.iam_role}"
  enable_grafana              = "${var.enable_grafana}"
}

module "metrics_server" {
  source = "./modules/metrics_server"
}

module "auth_operator" {
  source = "./modules/auth_operator"
}
