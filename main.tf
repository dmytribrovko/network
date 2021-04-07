terraform {
  required_version = ">=0.14"
}
locals {
  service_name = "${var.tags["Environment"]} ${var.tags["Project"]}"
}

#------- VPC -------
resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr_vpc
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = merge( { Name = "${local.service_name}-VPC" },
         var.tags
  )
}
#------- Gateway -------
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags   = merge( { Name = "${local.service_name}-IGW" },
           var.tags
  )
}

#------- Subnet public --------
resource "aws_subnet" "subnet_public" {
  count                   = length(var.public_subnets)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnets[count.index]
  map_public_ip_on_launch = "true"
  availability_zone       = element(data.aws_availability_zones.zones.names, count.index )
  tags                    = merge( { Name = "${local.service_name}-Public Subnet" },
                            var.tags
  )
}

#-------- Route ----------
resource "aws_route_table" "rtb_public" {
  vpc_id       = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags         = merge( { Name = "${local.service_name}-Public RTB" },
                 var.tags
  )
}

#------ Route table association ------
resource "aws_route_table_association" "rta_subnet" {
  count          = length(var.public_subnets)
  subnet_id      = element(aws_subnet.subnet_public.*.id, count.index )
  route_table_id = aws_route_table.rtb_public.id
}

#------- Subnet private --------
resource "aws_subnet" "subnet_private" {
  count             = length(var.private_subnets)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnets[count.index]
  availability_zone = element(data.aws_availability_zones.zones.names, count.index)
  tags              = merge( { Name = "${local.service_name}-Private Subnet" },
                      var.tags
  )
}

#------- ElasticIP ----
resource "aws_eip" "nat_eip" {
  count    = length(var.private_subnets)
  vpc      = true
  tags     = merge( { Name = "${local.service_name}-Private IP RTB" },
             var.tags
  )
}

#------- NAT gateway --------
resource "aws_nat_gateway" "private" {
  count         = length(var.public_subnets)
  allocation_id = element(aws_eip.nat_eip.*.id, count.index)
  subnet_id     = element(aws_subnet.subnet_public.*.id, count.index)
  tags          = merge( { Name = "${local.service_name}-Private NAT gateway" },
                  var.tags
  )
}

#-------- Route ----------
resource "aws_route_table" "rtb_private" {
  count            = length(var.private_subnets)
  vpc_id           = aws_vpc.vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.private.*.id, count.index)
  }
  tags          = merge( { Name = "${local.service_name}-Private Route" },
                  var.tags
  )
}

#------- Route table association ------
resource "aws_route_table_association" "rta_privsubnet" {
  count          = length(var.private_subnets)
  subnet_id      = element(aws_subnet.subnet_private.*.id, count.index )
  route_table_id = element(aws_route_table.rtb_private.*.id, count.index)
}

#------- SSH key ----------
resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ec2key" {
  key_name   = var.key_name
  public_key = tls_private_key.ssh.public_key_openssh
}

resource "local_file" "cloud_pem" {
  filename = var.key_name
  content  = tls_private_key.ssh.private_key_pem
}