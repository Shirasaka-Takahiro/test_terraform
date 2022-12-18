##VPC
resource "aws_vpc" "vpc" {
  cidr_block           = "${var.vpc}"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.general_config["project"]}-${var.general_config["environment"]}-vpc"
  }
}

##Public Subnet 1a
resource "aws_subnet" "public-subnet-1a" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "${var.public_subnet_1a}"
  availability_zone       = "${var.availability_zone_1a}"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.general_config["project"]}-${var.general_config["environment"]}-public-1a"
  }

}
##Public Subnet 1a
resource "aws_subnet" "public-subnet-1c" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "${var.public_subnet_1c}"
  availability_zone       = "${var.availability_zone_1c}"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.general_config["project"]}-${var.general_config["environment"]}-public-1c"
  }

}

##Private Subnets
resource "aws_subnet" "private-subnet-1a" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "${var.private_subnet_1a}"
  availability_zone = "${var.availability_zone_1a}"

  tags = {
    Name = "${var.general_config["project"]}-${var.general_config["environment"]}-private-1a"
  }

}

##Private Subnets
resource "aws_subnet" "private-subnet-1c" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "${var.private_subnet_1c}"
  availability_zone = "${var.availability_zone_1c}"

  tags = {
    Name = "${var.general_config["project"]}-${var.general_config["environment"]}-private-1c"
  }

}

##Internet Gateway
resource "aws_internet_gateway" "internet-gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.general_config["project"]}-${var.general_config["environment"]}-igw"
  }
}

##Public Route Table
resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.general_config["project"]}-${var.general_config["environment"]}-public-rtb"
  }

}

##Public Internet Gateway
resource "aws_route" "public-internet-gateway" {
  gateway_id             = aws_internet_gateway.internet-gateway.id
  route_table_id         = aws_route_table.public-route-table.id
  destination_cidr_block = "0.0.0.0/0"
}

##Public Routes Association 1a
resource "aws_route_table_association" "public-route-association-1a" {
  subnet_id      = aws_subnet.public-subnet-1a.id
  route_table_id = aws_route_table.public-route-table.id
}

##Public Routes Association 1c
resource "aws_route_table_association" "public-route-association-1c" {
  subnet_id      = aws_subnet.public-subnet-1c.id
  route_table_id = aws_route_table.public-route-table.id
}

##Private Route Table
resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.general_config["project"]}-${var.general_config["environment"]}-private-rtb"
  }

}

##Private Routes Association 1a
resource "aws_route_table_association" "private-route-table-association-1a" {
  subnet_id   = aws_subnet.private-subnet-1a.id
  route_table_id = aws_route_table.private-route-table.id
}

##Private Routes Association 1c
resource "aws_route_table_association" "private-route-table-association-1c" {
  subnet_id   = aws_subnet.private-subnet-1c.id
  route_table_id = aws_route_table.private-route-table.id
}