variable "environment_type" {
  default     = "prod"
  type        = string
  description = "Type of environment e.g 'prod', 'stage'"
}

variable "app" {
  default     = "internal-services"
  type        = string
  description = "Name of app that the VPC hosts"
}

variable "region" {
  default     = "us-east-1"
  type        = string
  description = "AWS region for deployment"
}

variable "cidr_block" {
  default     = "10.8.0.0/16"
  type        = string
  description = "The VPC cidr"
}

variable "private_subnet_cidr_blocks" {
  default     = ["10.8.0.0/18", "10.8.64.0/18", "10.8.128.0/18"]
  type        = list(any)
  description = "List of private subnet CIDR blocks"
}

variable "public_subnet_cidr_blocks" {
  default     = ["10.8.192.0/24", "10.8.193.0/24", "10.8.194.0/24"]
  type        = list(any)
  description = "List of public subnet CIDR blocks"
}

variable "enable_dns_support" {
  default     = true
  type        = bool
  description = "To enable DNS support in the VPC"
}

variable "enable_dns_hostnames" {
  default     = true
  type        = bool
  description = "To enable DNS hostnames in the VPC"
}
