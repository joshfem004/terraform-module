output "vpc_id" {
  value       = aws_vpc.main.id
  description = "ID of the VPC"
}

output "public_subnet_ids" {
  value       = aws_subnet.public-subnets.*.id
  description = "List of public subnet IDs"
}

output "private_subnet_ids" {
  value       = aws_subnet.private-subnets.*.id
  description = "List of private subnet IDs"
}

output "vpc-cidr-block" {
  value       = aws_vpc.main.cidr_block
  description = "CIDR block of the VPC"
}
