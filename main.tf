module "okta" {
  source       = "./okta"
  project      = var.oktaasa_project
  groups       = var.oktaasa_groups
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "showcase-demo-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-2a", "us-east-2b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Terraform   = "true"
    Name        = var.name
    Environment = var.environment
  }
}

module "instances" {
  source           = "./instances"
  vpc_id           = module.vpc.vpc_id
  name             = var.name
  environment      = var.environment
  instances        = var.instances
  public_subnet    = module.vpc.public_subnets[0]
  private_subnet   = module.vpc.private_subnets[0]
  sftd_version     = var.sftd_version
  enrollment_token = module.okta.enrollment_token
}

