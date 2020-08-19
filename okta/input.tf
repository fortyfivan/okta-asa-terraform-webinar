variable "project" {
  type        = string
  description = "Name of the ASA Project"
}

variable "groups" {
  type        = list(string)
  description = "Name of the ASA Groups"
}