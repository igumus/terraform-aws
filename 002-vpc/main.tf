data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main"
  }
}

resource "aws_subnet" "public" {
  for_each = var.vpc_subnets

  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, each.value + 100)
  availability_zone       = data.aws_availability_zones.available.names[each.value - 1]
  map_public_ip_on_launch = true

  tags = {
    Name   = "pub-${each.key}"
    Tier   = "public"
    Parent = var.vpc_name
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name   = "${var.vpc_name}-public-rtb"
    Tier   = "public"
    Parent = var.vpc_name
  }
}

resource "aws_route_table_association" "public" {
  depends_on     = [aws_subnet.public]
  route_table_id = aws_route_table.public.id
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
}

resource "aws_eip" "eip" {
  depends_on = [aws_internet_gateway.igw]
  domain     = "vpc"
  tags = {
    Name = "main"
  }
}

resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public[var.vpc_primary_subnet_name].id

  tags = {
    Name = "main"
  }

  depends_on = [aws_subnet.public]
}

resource "aws_subnet" "private" {
  for_each = var.vpc_subnets

  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, each.value)
  availability_zone       = data.aws_availability_zones.available.names[each.value - 1]
  map_public_ip_on_launch = false

  tags = {
    Name   = "priv-${each.key}"
    Tier   = "private"
    Parent = var.vpc_name
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw.id
  }

  tags = {
    Name   = "${var.vpc_name}-private-rtb"
    Tier   = "private"
    Parent = var.vpc_name
  }
}

resource "aws_route_table_association" "private" {
  depends_on     = [aws_subnet.private]
  route_table_id = aws_route_table.private.id
  for_each       = aws_subnet.private
  subnet_id      = each.value.id
}