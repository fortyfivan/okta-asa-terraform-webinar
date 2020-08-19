variable "secret_key" {
}

variable "access_key" {
}

variable "oktaasa_team" {
}

variable "oktaasa_key" {
}

variable "oktaasa_secret" {
}

provider "aws" {
  region     = "us-east-2"
  secret_key = var.secret_key
  access_key = var.access_key
}

provider "oktaasa" {
  oktaasa_team   = var.oktaasa_team
  oktaasa_key    = var.oktaasa_key
  oktaasa_secret = var.oktaasa_secret
}

variable "name" {
  type    = string
  default = "showcase"
}

variable "environment" {
  type    = string
  default = "showcase-demo"
}

variable "sftd_version" {
  type    = string
  default = "1.44.6"
}

variable "instances" {
  type = number
  default = 3
}

variable "oktaasa_project" {
  description = "Name of the ASA Project"
  default     = "showcase-project"
}

variable "oktaasa_groups" {
  type    = list(string)
  default = ["PP_InfoSec", "PP_DevOps"]
}

