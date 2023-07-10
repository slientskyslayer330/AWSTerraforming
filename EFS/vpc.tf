resource "aws_vpc" "helloCloudTesting" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_subnet" "public_subnets" {
  for_each          = var.subnets.public.cidrs
  vpc_id            = aws_vpc.helloCloudTesting.id
  cidr_block        = each.value
  availability_zone = each.key
  tags = {
    Name = replace(each.key, "ap-southeast", "public")
  }
}

resource "aws_subnet" "private_subnets" {
  for_each          = var.subnets.private.cidrs
  vpc_id            = aws_vpc.helloCloudTesting.id
  cidr_block        = each.value
  availability_zone = each.key
  tags = {
    Name = replace(each.key, "ap-southeast", "private")
  }
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.helloCloudTesting.id

  tags = {
    Name = "igw-helloCloudTesting"
  }
}

resource "aws_route_table" "public_sub_internet_rt" {
  vpc_id = aws_vpc.helloCloudTesting.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name = "rt-hellocloudtesting"
  }
}

resource "aws_route_table_association" "public_sub_internet_rt_asso" {
  for_each       = var.subnets.public.cidrs
  subnet_id      = aws_subnet.public_subnets[each.key].id
  route_table_id = aws_route_table.public_sub_internet_rt.id
}


