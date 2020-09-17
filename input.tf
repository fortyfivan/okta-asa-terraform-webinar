variable "gcp_project" {}

variable "gcp_region" {
  default = "europe-north1"
}

variable "gcp_zone" {
  default = "europe-north1-a"
}

variable "oktaasa_team" {}

variable "oktaasa_key" {}

variable "oktaasa_secret" {}

provider "oktaasa" {
  oktaasa_team   = var.oktaasa_team
  oktaasa_key    = var.oktaasa_key
  oktaasa_secret = var.oktaasa_secret
}

variable "name" {
  type    = string
  default = "okta-asa"
}

variable "environment" {
  type    = string
  default = "okta-asa-env"
}

variable "sftd_version" {
  type    = string
  default = "1.44.6"
}

variable "instances" {
  type    = number
  default = 3
}

variable "oktaasa_project" {
  description = "Name of the ASA Project"
  default     = "asa-project"
}

variable "oktaasa_groups" {
  type = list(string)
}

