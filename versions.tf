terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    oktaasa = {
      source = "terraform-providers/oktaasa"
    }
  }
  required_version = ">= 0.13"
}
