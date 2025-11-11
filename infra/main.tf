provider "aws" {
  region = var.region
}

locals {
  full_jenkins_domain_name = "${var.jenkins_subdomain}.${var.domain_name}"
  full_argocd_domain_name  = "${var.argocd_subdomain}.${var.domain_name}"
}

resource "aws_route53_zone" "main" {
  name = var.domain_name
}
module "ecr" {
  source               = "./modules/ecr"
  ecr_repository_names = var.ecr_repository_names
}

module "networking" {
  source             = "./modules/networking"
  vpc_cidr           = var.vpc_cidr
  public_subnets     = var.public_subnets
  private_subnets    = var.private_subnets
  availability_zones = var.availability_zones
  tags               = var.project_tags
}

module "security" {
  source = "./modules/security"
  vpc_id = module.networking.vpc_id
  tags   = var.project_tags
}

module "iam_roles" {
  source              = "./modules/iam_roles"
  role_name           = var.jenkins_iam_role_name
  instance_profile_name = var.jenkins_iam_instance_profile_name
  tags                = var.project_tags
}

module "acm" {
  source                   = "./modules/acm"
  domain_name              = var.domain_name
  route53_zone_id          = aws_route53_zone.main.zone_id
  tags                     = var.project_tags
}

module "compute" {
  source                        = "./modules/compute"
  ami_id                        = var.ami_id
  key_name                      = var.key_name
  private_subnet_id             = module.networking.private_subnets[0]
  public_subnet_id              = module.networking.public_subnets[0]
  private_sg_id                 = module.security.private_sg_id
  public_sg_id                  = module.security.public_sg_id
  k8s_node_instance_type        = var.k8s_node_instance_type
  bastion_instance_type         = var.bastion_instance_type
  jenkins_instance_type         = var.jenkins_instance_type
  jenkins_iam_instance_profile_name = module.iam_roles.jenkins_ecr_instance_profile_name
  tags                          = var.project_tags
  depends_on = [module.networking]
}

module "alb" {
  source                        = "./modules/alb"
  vpc_id                        = module.networking.vpc_id
  public_subnets                = module.networking.public_subnets
  public_sg_id                  = module.security.public_sg_id
  acm_certificate_arn           = module.acm.certificate_arn
  k8s_node_id                   = module.compute.private_node_id
  jenkins_node_id               = module.compute.jenkins_node_id
  alb_name                      = var.alb_name
  k8s_target_group_name         = var.k8s_target_group_name
  jenkins_target_group_name     = var.jenkins_target_group_name
  k8s_target_port               = var.k8s_target_port
  jenkins_target_port           = var.jenkins_target_port
  full_jenkins_domain_name      = local.full_jenkins_domain_name
  jenkins_listener_rule_priority = var.jenkins_listener_rule_priority
  tags                          = var.project_tags
}

module "route53_app_record" {
  source         = "./modules/route53"
  zone_id        = aws_route53_zone.main.zone_id
  record_name    = var.domain_name
  alias_dns_name = module.alb.alb_dns_name
  alias_zone_id  = module.alb.alb_zone_id
}

module "route53_jenkins_record" {
  source         = "./modules/route53"
  zone_id        = aws_route53_zone.main.zone_id
  record_name    = local.full_jenkins_domain_name
  alias_dns_name = module.alb.alb_dns_name
  alias_zone_id  = module.alb.alb_zone_id
}

module "route53_argocd_record" {
  source         = "./modules/route53"
  zone_id        = aws_route53_zone.main.zone_id
  record_name    = local.full_argocd_domain_name
  alias_dns_name = module.alb.alb_dns_name
  alias_zone_id  = module.alb.alb_zone_id
}