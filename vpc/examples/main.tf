###########################
# PROVIDER CONFIGURATION
###########################

terraform {
  required_providers {
    aws = "~> 3.6"
  }
}

provider "aws" {
  region              = var.region

  default_tags {
    tags = {
      Environment = "${var.environment_type}-${var.app}"
      App         = var.app
      Managed_by  = "DevOps"
      Automation  = "Terraform"
    }
  }
}

###########################
# CREATE VPC
###########################

module "vpc" {
  source = "../"

  environment_type           = var.environment_type
  app                        = var.app
  region                     = var.region
  cidr_block                 = var.cidr_block
  private_subnet_cidr_blocks = var.private_subnet_cidr_blocks
  public_subnet_cidr_blocks  = var.public_subnet_cidr_blocks
  enable_dns_support         = var.enable_dns_support
  enable_dns_hostnames       = var.enable_dns_hostnames
}
