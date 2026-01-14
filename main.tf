module "organizations" {
  source      = "./modules/organizations"
  domain_name = var.domain_name
}

module "logging" {
  source       = "./modules/logging"
  project_name = var.project_name
  aws_region   = var.aws_region
}

module "networking" {
  source          = "./modules/networking"
  project_name    = var.project_name
  vpc_cidr        = var.vpc_cidr
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets
  azs             = var.azs
}

module "iam" {
  source       = "./modules/iam"
  project_name = var.project_name
}
