# fetch azs from regions dynamically
data "aws_availability_zones" "azs" {}

# labels 
variable "namespace" {
  type        = string
  description = "Namespace, which could be your organization name or abbreviation, e.g. 'infused'"
}

variable "name" {
  type        = string
  description = "business owner name, e.g. `huntingspots` or `rally`"
}

variable "delimiter" {
  type        = string
  default     = "-"
  description = "Delimiter to be used between `namespace`, `stage`, `name` and `attributes`"
}

variable "attributes" {
  type        = list(string)
  default     = []
  description = "Additional attributes (e.g. `1`)"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags (e.g. `map('BusinessUnit','XYZ')` or merge(module.label.tags, map('Region', var.vpc_location))"
}

# VPC
variable "enabled" {
  type        = bool
  default     = true
  description = "Controls if VPC should be created (it affects almost all resources)"
}

variable "instance_tenancy" {
  default = "default"
}

variable "enable_dns_support" {
  default = "true"
}

variable "enable_dns_hostnames" {
  default = "true"
}

variable "vpc_cidr_block" {
  default = ""
}

variable "igw_name" {
  type    = string
  default = "igw"
}

variable "map_public_ip_on_launch" {
  default = "true"
}

#public
variable "vpc_public_subnet_name" {
  type    = string
  default = "public_subnet"
}

variable "vpc_public_subnet_cidr" {
  type = list(string)
}

variable "vpc_public_subnet_rt_name" {
  type    = string
  default = "public_route_table"
}

variable "public_route_cidr" {
  default = ""
}

# private
variable "vpc_private_subnet_name" {
  default = "private_subnet"
}

variable "vpc_private_subnet_cidr" {
  type = list(string)
}

variable "vpc_private_subnet_rt_name" {
  default = "private_route_table"
}

variable "private_route_cidr" {
  default = ""
}

# nat gateways
variable "total_nat_gateway_required" {
  default = "1"
}

# eip for nat gateway 
variable "eip_for_nat_gateway_name" {
  default = "eip_for_nat_gateway"
}

variable "nat_gateway_name" {
  default = "nat_gw"
}
