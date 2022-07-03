locals {
  namespace  = var.namespace
  name       = var.name
  delimiter  = var.delimiter
  attributes = var.attributes
  tags       = var.tags
}

# configure vpc 
resource "aws_vpc" "this_vpc" {
  count                = var.enabled ? 1 : 0
  cidr_block           = var.vpc_cidr_block
  instance_tenancy     = var.instance_tenancy
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames
  tags                 = var.tags
}

# configure internet gateway
resource "aws_internet_gateway" "this_igw" {
  count  = var.enabled && length(var.vpc_public_subnet_cidr) > 0 ? 1 : 0
  vpc_id = aws_vpc.this_vpc[0].id
  tags   = var.tags
}

# configure public subnets
resource "aws_subnet" "this_public_subnet" {
  count                   = var.enabled && length(var.vpc_public_subnet_cidr) > 0 ? length(var.vpc_public_subnet_cidr) : 0
  availability_zone       = data.aws_availability_zones.azs.names[count.index]
  vpc_id                  = aws_vpc.this_vpc[0].id
  cidr_block              = var.vpc_public_subnet_cidr[count.index]
  map_public_ip_on_launch = var.map_public_ip_on_launch
  tags = {
    Name = "${var.namespace}-${var.vpc_public_subnet_name}"
    Tier = "public"
  }
}

# route table for public subnets
resource "aws_route_table" "this_public_rt" {
  vpc_id = aws_vpc.this_vpc[0].id
  route {
    cidr_block = var.public_route_cidr
    gateway_id = aws_internet_gateway.this_igw[0].id
  }

  tags = {
    Name = "${var.namespace}-${var.vpc_public_subnet_rt_name}"
  }
}

# associate or link public route table with public subnets
resource "aws_route_table_association" "this_public_aws_rt_assoc" {
  count          = var.enabled && length(var.vpc_public_subnet_cidr) > 0 ? length(var.vpc_public_subnet_cidr) : 0
  route_table_id = aws_route_table.this_public_rt.id
  subnet_id      = aws_subnet.this_public_subnet.*.id[count.index]
}

# configure private subnets
resource "aws_subnet" "this_private_subnet" {
  count             = var.enabled && length(var.vpc_private_subnet_cidr) > 0 ? length(var.vpc_private_subnet_cidr) : 0
  availability_zone = data.aws_availability_zones.azs.names[count.index]
  vpc_id            = aws_vpc.this_vpc[0].id
  cidr_block        = var.vpc_private_subnet_cidr[count.index]

  tags = {
    Name = "${var.namespace}-${var.vpc_private_subnet_name}-${count.index + 1}"
    Tier = "private"
  }
}

# route table for private subnets
resource "aws_route_table" "this_private_rt" {
  count  = var.enabled && length(var.vpc_private_subnet_cidr) > 0 ? length(var.vpc_private_subnet_cidr) : 0
  vpc_id = aws_vpc.this_vpc[0].id
  route {
    cidr_block = var.private_route_cidr
    # nat_gateway_id = element(aws_nat_gateway.this_ngw[0].id)
    gateway_id = aws_internet_gateway.this_igw[0].id
  }

  tags = {
    Name = "${var.namespace}-${var.vpc_private_subnet_rt_name}-${count.index + 1}"
  }
}

# associate or link private route table with private subnets
resource "aws_route_table_association" "this_private_aws_rt_assoc" {
  count          = var.enabled && length(var.vpc_private_subnet_cidr) > 0 ? length(var.vpc_private_subnet_cidr) : 0
  route_table_id = aws_route_table.this_private_rt.*.id[count.index]
  subnet_id      = aws_subnet.this_private_subnet.*.id[count.index]
}

# elastic ip for nat gateway
resource "aws_eip" "this_eip_ngw" {
  count = var.enabled && var.total_nat_gateway_required > 0 ? var.total_nat_gateway_required : 0

  tags = {
    Name = "${var.namespace}${var.eip_for_nat_gateway_name}-${count.index + 1}"
  }
}

# configure nat gateways in public-subnets, each nat-gateway will be in different az
resource "aws_nat_gateway" "this_ngw" {
  count         = var.enabled && var.total_nat_gateway_required > 0 ? var.total_nat_gateway_required : 0
  allocation_id = aws_eip.this_eip_ngw.*.id[count.index]
  subnet_id     = aws_subnet.this_public_subnet.*.id[count.index]

  tags = {
    Name = "${var.namespace}-${count.index + 1}"
  }
}
