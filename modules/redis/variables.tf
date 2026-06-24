variable "location" {}

variable "resource_group_name" {}

variable "subnet_id" {}

variable "redis_dns_zone_id" {
  description = "Private DNS Zone ID for Managed Redis"
  type        = string
}
