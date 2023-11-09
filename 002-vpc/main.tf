data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  availability_zone_count = length(data.aws_availability_zones.available)
  public_subnet_count     = var.vpc_public_subnet_count > local.availability_zone_count ? local.availability_zone_count : var.vpc_public_subnet_count
  private_subnet_count    = var.vpc_private_subnet_count > local.availability_zone_count ? local.availability_zone_count : var.vpc_private_subnet_count
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
  count = local.public_subnet_count

  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index + 100)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name   = "pub-subnet-${count.index}"
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
    Name   = "public-rtb"
    Tier   = "public"
    Parent = var.vpc_name
  }
}

resource "aws_route_table_association" "public" {
  depends_on     = [aws_subnet.public]
  route_table_id = aws_route_table.public.id
  count          = local.public_subnet_count
  subnet_id      = aws_subnet.public[count.index].id
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
  subnet_id     = aws_subnet.public[0].id

  tags = {
    Name = "main"
  }

  depends_on = [aws_subnet.public]
}

resource "aws_subnet" "private" {
  count = local.private_subnet_count

  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name   = "priv-subnet-${count.index}"
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
  count          = local.private_subnet_count
  subnet_id      = aws_subnet.private[count.index].id
}