output "vpc_id" {
  value = module.vpc.vpc_id
}

output "private_subnets" {
  value = module.vpc.private_subnet_ids
}

output "public_subnets" {
  value = module.vpc.public_subnet_ids
}

output "vpc_cidr_block" {
  value = module.vpc.vpc-cidr-block
}

output "account_id" {
  value = local.account_id
}

output "environment_type" {
  value = var.environment_type
}

output "app" {
  value = var.app
}

output "region" {
  value = var.region
}
