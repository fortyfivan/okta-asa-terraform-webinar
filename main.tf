module "okta" {
  source  = "./okta"
  project = var.oktaasa_project
  groups  = var.oktaasa_groups
}

module "network" {
  source       = "terraform-google-modules/network/google"
  version      = "2.5.0"
  network_name = "showcase-demo-vpc"
  project_id   = var.gcp_project

  subnets = [
    {
      subnet_name   = "subnet-01"
      subnet_ip     = "10.0.1.0/24"
      subnet_region = var.gcp_region
    },
    {
      subnet_name           = "subnet-02"
      subnet_ip             = "10.0.2.0/24"
      subnet_region         = var.gcp_region
      subnet_private_access = "true"
      subnet_flow_logs      = "true"
    },
  ]
}

module "instances" {
  source           = "./instances"
  network          = module.network.network_name
  name             = var.name
  environment      = var.environment
  instances        = var.instances
  sftd_version     = var.sftd_version
  enrollment_token = module.okta.enrollment_token
}

