##VPC
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.general_config["project"]}-${var.general_config["environment"]}-vpc"
  }
}

##Public Subnet
resource "aws_subnet" "public-subnets" {
  vpc_id = aws_vpc.vpc.id
  for_each = var.subnets.public_subnets
  cidr_block = each.value.cidr
  availability_zone = each.value.az

  tags = {
    Name = "${var.general_config["project"]}-${var.general_config["environment"]}-${each.value.name}"
  }
}

##Public Subnet
resource "aws_subnet" "private-subnets" {
  vpc_id = aws_vpc.vpc.id
  for_each = var.subnets.private_subnets
  cidr_block = each.value.cidr
  availability_zone = each.value.az

  tags = {
    Name = "${var.general_config["project"]}-${var.general_config["environment"]}-${each.value.name}"
  }
}

##Public Route Tables
resource "aws_route_table" "public-route-tables" {
  vpc_id = aws_vpc.vpc.id
  for_each = var.subnets.public_subnets

  tags = {
    Name = "${var.general_config["project"]}-${var.general_config["environment"]}-public-rtb"
  }

}

##Private Route Tables
resource "aws_route_table" "private-route-tables" {
  vpc_id = aws_vpc.vpc.id
  for_each = var.subnets.public_subnets

  tags = {
    Name = "${var.general_config["project"]}-${var.general_config["environment"]}-private-rtb"
  }

}

##Internet Gateway
resource "aws_internet_gateway" "internet-gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.general_config["project"]}-${var.general_config["environment"]}-igw"
  }
}

##Public Internet Gateway
resource "aws_route" "public-internet-gateway" {
  for_each = var.subnets.public_subnets
  gateway_id             = aws_internet_gateway.internet-gateway.id
  route_table_id         = aws_route_table.public-route-tables[each.key].id
  destination_cidr_block = "0.0.0.0/0"
}

##Public Routes Association
resource "aws_route_table_association" "public-routes-association" {
  for_each = var.subnets.public_subnets
  subnet_id      = aws_subnet.public-subnets[each.key].id
  route_table_id = aws_route_table.public-route-tables[each.key].id
}

##private Routes Association
resource "aws_route_table_association" "private-routes-association" {
  for_each = var.subnets.private_subnets
  subnet_id      = aws_subnet.private_subnets[each.key].id
  route_table_id = aws_route_table.private-route-tables[each.key].id
}