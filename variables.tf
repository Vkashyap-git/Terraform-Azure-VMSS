variable "location" {}

variable "resource_group_name" {}

variable "admin_username" {}

variable "ssh_public_key" {}

variable "ghcr_username" {
  default = ""
}

variable "ghcr_token" {
  default = ""
}
