provider "aws" {
  region = var.region
}

resource "aws_vpc" "team2" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "team2-vpc"
  }
}

data "aws_availability_zones" "available" {}

# Public Subnet
resource "aws_subnet" "public" {
  count             = var.num_public_subnets
  vpc_id            = aws_vpc.team2.id
  cidr_block        = element(var.public_subnet_cidrs, count.index)
  availability_zone = element(data.aws_availability_zones.available.names, 0)  # Use the first AZ

  map_public_ip_on_launch = true

  tags = {
    Name = "team2-public-subnet-${count.index}"
  }
}

# Private Subnet
resource "aws_subnet" "private" {
  count             = var.num_private_subnets
  vpc_id            = aws_vpc.team2.id
  cidr_block        = element(var.private_subnet_cidrs, count.index)
  availability_zone = element(data.aws_availability_zones.available.names, 1)  # Use a different AZ

  tags = {
    Name = "team2-private-subnet-${count.index}"
  }
}

resource "aws_internet_gateway" "team2" {
  vpc_id = aws_vpc.team2.id

  tags = {
    Name = "team2-igw"
  }
}

# Route Tables for Public Subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.team2.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.team2.id
  }

  tags = {
    Name = "team2-public-rt"
  }
}

resource "aws_route_table_association" "public" {
  count          = var.num_public_subnets
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# NAT Gateways
resource "aws_eip" "nat" {
  count = var.num_nat_gateways
  domain = "vpc"

  tags = {
    Name = "team2-eip-${count.index}"
  }
}

resource "aws_nat_gateway" "nat" {
  count           = var.num_nat_gateways
  allocation_id   = aws_eip.nat[count.index].id
  subnet_id       = aws_subnet.public[count.index].id

  tags = {
    Name = "team2-nat-gateway-${count.index}"
  }
}

# Route Tables for Private Subnets
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.team2.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat[0].id
  }

  tags = {
    Name = "team2-private-rt"
  }
}

resource "aws_route_table_association" "private" {
  count          = var.num_private_subnets
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}
