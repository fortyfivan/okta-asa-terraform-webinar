terraform {
  required_providers {
    aws = {
      source = "hashicorp/google"
    }
    oktaasa = {
      source = "terraform-providers/oktaasa"
    }
  }
  required_version = ">= 0.13"
}
