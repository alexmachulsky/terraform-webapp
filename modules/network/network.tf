resource "aws_vpc" "webapp-vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "webapp-vpc"
  }
}

resource "aws_internet_gateway" "webapp-gateway" {
  vpc_id = aws_vpc.webapp-vpc.id
  tags = {
    Name = "webapp-gateway"
  }
}

resource "aws_subnet" "webapp-subnet_1" {
  vpc_id                  = aws_vpc.webapp-vpc.id
  cidr_block              = var.subnet1_cidr
  availability_zone       = var.subnet1_az
  map_public_ip_on_launch = true
  tags = {
    Name = "webapp-subnet_1"
  }
}

resource "aws_subnet" "webapp-subnet_2" {
  count                   = var.create_second_subnet ? 1 : 0
  vpc_id                  = aws_vpc.webapp-vpc.id
  cidr_block              = var.subnet2_cidr
  availability_zone       = var.subnet2_az
  map_public_ip_on_launch = true
  tags = {
    Name = "webapp-subnet_2"
  }
}

resource "aws_route_table" "webapp-route-table" {
  vpc_id = aws_vpc.webapp-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.webapp-gateway.id
  }
  tags = {
    Name = "webapp-route-table"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.webapp-subnet_1.id
  route_table_id = aws_route_table.webapp-route-table.id
}

resource "aws_route_table_association" "b" {
  count          = var.create_second_subnet ? 1 : 0
  subnet_id      = aws_subnet.webapp-subnet_2[0].id
  route_table_id = aws_route_table.webapp-route-table.id
}
