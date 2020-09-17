module "okta" {
  source  = "./okta"
  project = var.oktaasa_project
  groups  = var.oktaasa_groups
}

module "network" {
  source  = "terraform-google-modules/network/google"
  version = "2.5.0"

  network_name = "showcase-demo-vpc"
  project_id   = var.gcp_project

  subnets = [
    {
      subnet_name   = "subnet-01"
      subnet_ip     = "10.0.1.0/24"
      subnet_region = var.gcp_region
    },
  ]
}

module "instances" {
  source           = "./instances"
  subnetwork       = module.network.subnets_names[0]
  name             = var.name
  environment      = var.environment
  instances        = var.instances
  sftd_version     = var.sftd_version
  enrollment_token = module.okta.enrollment_token

  depends_on = [module.network]
}

resource "google_compute_firewall" "ssh" {
  name    = "${module.network.network_name}-allow-ssh"
  network = module.network.network_name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  target_tags = ["bastion"]
}
