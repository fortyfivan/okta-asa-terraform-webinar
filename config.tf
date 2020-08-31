terraform {
  required_providers {
    oktaasa = {
      source = "terraform-providers/oktaasa"
    }
    google = {
      source = "hashicorp/google"
    }
  }
  required_version = ">= 0.13"
}

provider "google" {
  region  = "europe-north1"
  project = "emil-engfors-playground"
}
