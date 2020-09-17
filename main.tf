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

  depends_on = [module.network, google_compute_router_nat.nat]
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
resource "google_compute_firewall" "internal_ssh" {
  name    = "${module.network.network_name}-allow-internal-ssh"
  network = module.network.network_name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_tags = ["bastion"]
  target_tags = ["okta-asa"]
}

resource "google_compute_router" "router" {
  name    = "nat-router"
  network = module.network.network_name
}

resource "google_compute_router_nat" "nat" {
  name                               = "nat"
  router                             = google_compute_router.router.name
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}
