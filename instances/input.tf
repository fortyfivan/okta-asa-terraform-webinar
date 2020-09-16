variable name {
  type = string
}

variable environment {
  type = string
}

variable vpc_id {
  type = string
}

variable instances {
  type = number
}

variable sftd_version {
  type = string
}

variable enrollment_token {
  type = string
}

variable gcp_zone {
  type    = string
  default = "europe-north1-a"
}
