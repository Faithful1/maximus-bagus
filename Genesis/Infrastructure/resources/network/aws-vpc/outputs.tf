# Output of VPC

output "vpc_id" {
  description = "The ID of the VPC"
  value       = concat(aws_vpc.this_vpc.*.id, [""])[0]
}

# Output of IGW
output "igw" {
  value = aws_internet_gateway.this_igw.*.id
}

# Output of EIP For NAT Gateways
output "eip-ngw" {
  value = aws_eip.this_eip_ngw.*.id
}

# Output Of NAT-Gateways
output "ngw" {
  value = aws_nat_gateway.this_ngw.*.id
}

# Output of Public Subnet
output "public_subnet_ids" {
  description = "Public Subnets IDS"
  value       = aws_subnet.this_public_subnet.*.id
}

# Output Of Private Subnet
output "private_subnet_ids" {
  description = "Private Subnets IDS"
  value       = aws_subnet.this_private_subnet.*.id
}

# Output Of Public Subnet Associations With Public Route Tables
output "public-association" {
  value = aws_route_table_association.this_public_aws_rt_assoc.*.id
}

# Output Of Public Route Table
output "aws-public-route-table" {
  value = aws_route_table.this_public_rt.*.id
}

# Output Of Region AZS
output "aws-availability-zones" {
  value = data.aws_availability_zones.azs.names
}

# Output Of Private Route Table ID's
output "aws-private-route-table" {
  value = aws_route_table.this_private_rt.*.id
}
