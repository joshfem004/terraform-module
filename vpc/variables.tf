variable "environment_type" {
  type        = string
  description = "Type of environment e.g 'prod', 'stage'"
}

variable "app" {
  type        = string
  description = "Name of app that the VPC hosts"
}

variable "region" {
  type        = string
  description = "Region for deployment"
}

variable "cidr_block" {
  type        = string
  description = "The VPC CIDR block"
}

variable "private_subnet_cidr_blocks" {
  type        = list(any)
  description = "List of all private subnet CIDR blocks"
}

variable "public_subnet_cidr_blocks" {
  type        = list(any)
  description = "List of all public subnet CIDR blocks"
}

variable "enable_dns_support" {
  type        = bool
  description = "To enable DNS support in the VPC"
}

variable "enable_dns_hostnames" {
  type        = bool
  description = "To enable DNS hostnames in the VPC"
}
