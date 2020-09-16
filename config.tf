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
  project = "var.gcp_project"
}
