locals {
  # FQDN of Thanos SRV registry
  srv_records = "_thanosstores._tcp.${var.domain_name}."

  bucket_name = "coveo-${var.env}-thanos"
}
