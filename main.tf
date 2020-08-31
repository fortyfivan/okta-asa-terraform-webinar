module "okta" {
  source  = "./okta"
  project = var.oktaasa_project
  groups  = var.oktaasa_groups
}

module "network" {
  source       = "terraform-google-modules/network/google"
  version      = "2.5.0"
  network_name = "showcase-demo-vpc"
  project_id   = "emil-engfors-playground"
  #cidr    = "10.0.0.0/16"

  #azs             = ["us-east-2a", "us-east-2b"]
  #private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  #public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]
  subnets = [
    {
      subnet_name   = "subnet-01"
      subnet_ip     = "10.10.10.0/24"
      subnet_region = "europe-north1"
    },
    {
      subnet_name           = "subnet-02"
      subnet_ip             = "10.10.20.0/24"
      subnet_region         = "europe-north1"
      subnet_private_access = "true"
      subnet_flow_logs      = "true"
    },
  ]

  #enable_nat_gateway = true
  #enable_vpn_gateway = true
  /*
  metadata = {
    Terraform   = "true"
    Name        = var.name
    Environment = var.environment
  }
  */
}

module "instances" {
  source      = "./instances"
  vpc_id      = module.network.network_name
  name        = var.name
  environment = var.environment
  instances   = var.instances
  #public_subnet    = module.vpc.public_subnets[0]
  #private_subnet   = module.vpc.private_subnets[0]
  sftd_version     = var.sftd_version
  enrollment_token = module.okta.enrollment_token
}

