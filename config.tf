terraform {
  required_providers {
    oktaasa = {
      source = "terraform-providers/oktaasa"
    }

    google = {
      source = "hashicorp/google"
    }
  }

  backend "remote" {
    organization = "Engfors"

    workspaces {
      prefix = "playground_"
    }
  }

  required_version = ">= 0.13"
}

provider "google" {
  region  = "europe-north1"
  zone    = "europe-north1-a"
  project = "var.gcp_project"
}
