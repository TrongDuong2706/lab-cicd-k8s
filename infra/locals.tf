locals {
  full_jenkins_domain_name = "${var.jenkins_subdomain}.${var.domain_name}"
  full_argocd_domain_name  = "${var.argocd_subdomain}.${var.domain_name}"

  env_records = {
    dev  = "dev.${var.domain_name}"
    uat  = "uat.${var.domain_name}"
    prod = var.domain_name  
  }

  # Tổng hợp tất cả records
  route53_records = merge(
    {
      app     = var.domain_name
      jenkins = local.full_jenkins_domain_name
      argocd  = local.full_argocd_domain_name
    },
    local.env_records
  )
}
