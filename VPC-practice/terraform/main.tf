locals {
  vpc = {
    cidr = "192.168.0.0/16"
    public_subnets = {
      # cidrs = []
      cidrs = ["192.168.1.0/24", "192.168.2.0/24", "192.168.3.0/24"]
      names = ["public-subnet-1", "public-subnet-2", "public-subnet-3"]
    }
    private_subnets = {
      cidrs = ["192.168.4.0/24", "192.168.5.0/24", "192.168.6.0/24"]
      names = ["private-subnet-1", "private-subnet-2", "private-subnet-3"]
    }
  }
}

data "aws_availability_zones" "singapore" {
  state = "available"
}

resource "aws_vpc" "non_prod" {
  cidr_block           = local.vpc.cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"
  tags = {
    Name = "non-prod-vpc"
  }
}

resource "aws_internet_gateway" "non_prod_igw" {
  vpc_id = aws_vpc.non_prod.id
  tags = {
    Name = "non-prod-igw"
  }
}

resource "aws_subnet" "public_subnets" {
  count                   = length(local.vpc.public_subnets.cidrs) > 0 ? length(local.vpc.public_subnets.cidrs) : 0
  vpc_id                  = aws_vpc.non_prod.id
  availability_zone       = data.aws_availability_zones.singapore.names[count.index]
  cidr_block              = local.vpc.public_subnets.cidrs[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = local.vpc.public_subnets.names[count.index]
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.non_prod.id
  tags = {
    Name = "public-route-table"
  }
}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.non_prod_igw.id
}

resource "aws_route_table_association" "route_table_assoc_public" {
  count          = length(aws_subnet.public_subnets) > 0 ? length(aws_subnet.public_subnets) : 0
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_subnet" "private_subnets" {
  count             = length(local.vpc.private_subnets.cidrs) > 0 ? length(local.vpc.private_subnets.cidrs) : 0
  vpc_id            = aws_vpc.non_prod.id
  availability_zone = data.aws_availability_zones.singapore.names[count.index]
  cidr_block        = local.vpc.private_subnets.cidrs[count.index]
  tags = {
    Name = local.vpc.private_subnets.names[count.index]
  }
}

resource "aws_eip" "nat_gateway_eip" {
  domain = "vpc"
  tags = {
    Name = "nat-gateway-eip"
  }
}

resource "aws_nat_gateway" "non_prod_nat" {
  allocation_id     = aws_eip.nat_gateway_eip.allocation_id
  connectivity_type = "public"
  subnet_id         = aws_subnet.public_subnets[0].id
  tags = {
    Name = "non-prod-NAT-gateway"
  }
}

resource "aws_route_table" "private_route_tables" {
  count  = length(aws_subnet.private_subnets) > 0 ? length(aws_subnet.private_subnets) : 0
  vpc_id = aws_vpc.non_prod.id
  tags = {
    Name = local.vpc.private_subnets.names[count.index]
  }
}

resource "aws_route" "natRoutes" {
  count = length(aws_route_table.private_route_tables) > 0 ? length(aws_route_table.private_route_tables) : 0
  route_table_id         = aws_route_table.private_route_tables[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_nat_gateway.non_prod_nat.id
}

resource "aws_route_table_association" "route_table_assoc_private_subnets" {
  count = length(aws_subnet.private_subnets) > 0 ? length(aws_subnet.private_subnets) : 0
  subnet_id = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private_route_tables[count.index].id
}

