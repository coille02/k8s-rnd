# output.tf 

# VPC
output "vpc_id" {
  description = "VPC ID"
  value       = try(aws_vpc.prod-vpc[0].id, "")
}

output "manage_vpc_id" {
  description = "VPC ID"
  value       = try(aws_vpc.manage-vpc[0].id, "")
}

output "dev_vpc_id" {
  description = "VPC ID"
  value       = try(aws_vpc.dev-vpc[0].id, "")
}

output "vpc_cidprod_block" {
  description = "VPC에 할당한 CIDR block"
  value       = try(aws_vpc.prod-vpc[0].cidprod_block, "")

}
output "manage_vpc_cidprod_block" {
  description = "VPC에 할당한 CIDR block"
  value       = try(aws_vpc.manage-vpc[0].cidprod_block, "")
}

output "dev_vpc_cidprod_block" {
  description = "VPC에 할당한 CIDR block"
  value       = try(aws_vpc.dev-vpc[0].cidprod_block, "")
}

output "default_security_group_id" {
  description = "VPC default Security Group ID"
  value       = aws_vpc.prod-vpc.*.default_security_group_id
}

# internet gateway
output "prod_igw_id" {
  description = "prod Interget Gateway ID"
  value       = try(aws_internet_gateway.prod_igw[0].id, "")
}

output "manage_igw_id" {
  description = "Manage Interget Gateway ID"
  value       = try(aws_internet_gateway.manage_igw[0].id, "")
}

output "dev_igw_id" {
  description = "dev Interget Gateway ID"
  value       = try(aws_internet_gateway.dev_igw[0].id, "")
}

# subnets
output "prod_private_subnets_ids" {
  description = "Private Subnet ID 리스트"
  value       = aws_subnet.prod-sn-private.*.id
}

output "prod_public_subnets_ids" {
  description = "Public Subnet ID 리스트"
  value       = aws_subnet.prod-sn-public.*.id
}


output "db_subnet_group_id" {
  description = "The db subnet group name"
  value       = try(aws_db_subnet_group.prod-sn-db[0].name, "")
}

output "redis_subnet_group_id" {
  description = "The db subnet group name"
  value       = try(aws_elasticache_subnet_group.prod-sn-redis[0].name, "")
}

output "dev_redis_subnet_group_id" {
  description = "The db subnet group name"
  value       = try(aws_elasticache_subnet_group.dev-sn-redis[0].name, "")
}

output "dev_aws_db_subnet_group_ids" {
  description = "Database Subnet Group ID ID 리스트"
  value       = aws_subnet.dev-sn-public.*.id
}

output "dev_subnets_ids" {
  description = "Database Subnet Group ID ID 리스트"
  value       = aws_subnet.dev-sn-public.*.id
}

output "manage_subnets_ids" {
  description = "Database Subnet Group ID ID 리스트"
  value       = aws_subnet.manage-sn-public.*.id
}

# route tables
output "public_route_table_ids" {
  description = "Public Route Table ID 리스트"
  value       = try(aws_default_route_table.prod-rtb-public[*].id, "")
}

output "private_route_table_ids" {
  description = "Private Route Table ID 리스트"
  value       = try(aws_route_table.prod-rtb-private[*].id, "")
}

output "manage_route_table_ids" {
  description = "Private Route Table ID 리스트"
  value       = try(aws_default_route_table.manage-rtb-public[0].id, "")
}

output "dev_route_table_ids" {
  description = "Private Route Table ID 리스트"
  value       = try(aws_default_route_table.dev-rtb-public[0].id, "")
}

# NAT gateway

output "nat_ids" {
  description = "NAT Gateway에 할당된 EIP ID 리스트"
  value       = aws_eip.nat.*.id
}

output "nat_public_ips" {
  description = "NAT Gateway에 할당된 EIP 리스트"
  value       = aws_eip.nat.*.public_ip
}

output "natgw_ids" {
  description = "NAT Gateway ID 리스트"
  value       = aws_nat_gateway.prod-ngw.*.id
}
