output "vpc_id" {
  description = "The ID of the VPC"
  value       = concat(aws_vpc.vpc.*.id, [""])[0]
}

output "vpc_arn" {
  description = "The ARN of the VPC"
  value       = concat(aws_vpc.vpc.*.arn, [""])[0]
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = concat(aws_vpc.vpc.*.cidr_block, [""])[0]
}

output "default_route_table_id" {
  description = "The ID of the default route table"
  value       = concat(aws_vpc.vpc.*.default_route_table_id, [""])[0]
}

output "vpc_instance_tenancy" {
  description = "Tenancy of instances spin up within VPC"
  value       = concat(aws_vpc.vpc.*.instance_tenancy, [""])[0]
}

output "vpc_main_route_table_id" {
  description = "The ID of the main route table associated with this VPC"
  value       = concat(aws_vpc.vpc.*.main_route_table_id, [""])[0]
}

output "private_subnets_id" {
  description = "List of IDs of private subnets"
  value       = aws_subnet.subnet_private.*.id
}

output "private_subnet_arns" {
  description = "List of ARNs of private subnets"
  value       = aws_subnet.subnet_private.*.arn
}

output "private_subnets_cidr_blocks" {
  description = "List of cidr_blocks of private subnets"
  value       = aws_subnet.subnet_private.*.cidr_block
}

output "public_subnets_id" {
  description = "List of IDs of public subnets"
  value       = aws_subnet.subnet_public.*.id
}

output "public_subnet_arns" {
  description = "List of ARNs of public subnets"
  value       = aws_subnet.subnet_public.*.arn
}

output "public_subnets_cidr_blocks" {
  description = "List of cidr_blocks of public subnets"
  value       = aws_subnet.subnet_public.*.cidr_block
}

output "private_route_table_ids" {
  description = "List of IDs of private route tables"
  value       = aws_route_table.rtb_private.*.id
}

output "private_route_table_association_ids" {
  description = "List of IDs of the private route table association"
  value       = aws_route_table_association.rta_subnet.*.id
}

output "nat_ids" {
  description = "List of allocation ID of Elastic IPs created for AWS NAT Gateway"
  value       = aws_eip.nat_eip.*.id
}

output "igw_id" {
  description = "The ID of the Internet Gateway"
  value       = concat(aws_internet_gateway.igw.*.id, [""])[0]
}

output "igw_arn" {
  description = "The ARN of the Internet Gateway"
  value       = concat(aws_internet_gateway.igw.*.arn, [""])[0]
}

output "azs" {
  description = "A list of availability zones specified as argument to this module"
  value       = data.aws_availability_zones.zones.names
}

output "name" {
  description = "The name of the VPC specified as argument to this module"
  value       = var.name
}