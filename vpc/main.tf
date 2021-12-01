locals {
  env_name       = "${var.environment_type}-${var.app}"
  sorted_az_list = sort(data.aws_availability_zones.available-zones.names)
}

# declaring all availability zones in the region
data "aws_availability_zones" "available-zones" {
  state = "available"
}

# create vpc
resource "aws_vpc" "main" {
  cidr_block           = var.cidr_block
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = {
    Name = "${local.env_name}-vpc"
  }
}

# create vpc endpoint
resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.main.id
  service_name = "com.amazonaws.${var.region}.s3"
  route_table_ids = flatten([
    aws_route_table.public-rtb.id,
    aws_route_table.private-rtb.id
  ])

  tags = {
    Name = "${local.env_name}-s3-vpc-endpoint"
  }
}

# create internet gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${local.env_name}-internet-gw"
  }
}

# create elastic IP for NAT gateway
resource "aws_eip" "nat-gw-eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.main]

  tags = {
    Name = "${local.env_name}-nat-gw-eip"
  }
}

# create private subnets
resource "aws_subnet" "private-subnets" {
  vpc_id                  = aws_vpc.main.id
  count                   = length(var.private_subnet_cidr_blocks)
  cidr_block              = var.private_subnet_cidr_blocks[count.index]
  map_public_ip_on_launch = false
  availability_zone       = local.sorted_az_list[count.index]

  tags = {
    Name = "${local.env_name}-private-subnet-${element(local.sorted_az_list, count.index)}"
  }
}

# create public subnets
resource "aws_subnet" "public-subnets" {
  vpc_id                  = aws_vpc.main.id
  count                   = length(var.public_subnet_cidr_blocks)
  cidr_block              = var.public_subnet_cidr_blocks[count.index]
  map_public_ip_on_launch = true
  availability_zone       = local.sorted_az_list[count.index]

  tags = {
    Name = "${local.env_name}-public-subnet-${element(local.sorted_az_list, count.index)}"
  }
}

# create NAT gateway
resource "aws_nat_gateway" "nat-gw" {
  allocation_id = aws_eip.nat-gw-eip.id
  subnet_id     = element(aws_subnet.public-subnets.*.id, 0)
  depends_on    = [aws_internet_gateway.main]

  tags = {
    Name = "${local.env_name}-nat-gw"
  }
}

# create private route table
resource "aws_route_table" "private-rtb" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gw.id
  }

  tags = {
    Name = "${local.env_name}-private-rtb"
  }
}

# associate all private subnets to the private route table
resource "aws_route_table_association" "private-subnets-assoc" {
  count          = length(var.private_subnet_cidr_blocks)
  subnet_id      = element(aws_subnet.private-subnets.*.id, count.index)
  route_table_id = aws_route_table.private-rtb.id
}

# create route table for the public subnets
resource "aws_route_table" "public-rtb" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "${local.env_name}-public-rtb"
  }
}

# associate all public subnets to the public route table
resource "aws_route_table_association" "public-subnets-assoc" {
  count          = length(var.public_subnet_cidr_blocks)
  subnet_id      = element(aws_subnet.public-subnets.*.id, count.index)
  route_table_id = aws_route_table.public-rtb.id
}
