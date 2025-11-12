locals {
  full_jenkins_domain_name = "${var.jenkins_subdomain}.${var.domain_name}"
  full_argocd_domain_name  = "${var.argocd_subdomain}.${var.domain_name}"

  route53_records = {
    app     = var.domain_name
    jenkins = local.full_jenkins_domain_name
    argocd  = local.full_argocd_domain_name
  }
}