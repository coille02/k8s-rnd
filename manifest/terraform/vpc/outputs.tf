# output.tf 

# VPC
output "vpc_id" {
  description = "VPC ID"
  value       = try(module.vpc.vpc_id, "")
}

output "m_vpc_id" {
  description = "VPC ID"
  value       = try(module.vpc.m_vpc_id, "")
}

output "q_vpc_id" {
  description = "VPC ID"
  value       = try(module.vpc.q_vpc_id, "")
}

output "vpc_cidr_block" {
  description = "VPC에 할당한 CIDR block"
  value       = try(module.vpc.vpc_cidr_block, "")
}

output "m_vpc_cidr_block" {
  description = "VPC에 할당한 CIDR block"
  value       = try(module.vpc.m_vpc_cidr_block, "")
}

output "q_vpc_cidr_block" {
  description = "VPC에 할당한 CIDR block"
  value       = try(module.vpc.q_vpc_cidr_block, "")
}

output "default_security_group_id" {
  description = "VPC default Security Group ID"
  value       = try(module.vpc.default_security_group_id,"")
}

# internet gateway
output "r_igw_id" {
  description = "prod Interget Gateway ID"
  value       = try(module.vpc.r_igw_id, "")
}

output "m_igw_id" {
  description = "Manage Interget Gateway ID"
  value       = try(module.vpc.m_igw_id, "")
}

output "q_igw_id" {
  description = "dev Interget Gateway ID"
  value       = try(module.vpc.q_igw_id, "")
}

# subnets
output "r_private_subnets_ids" {
  description = "Private Subnet ID 리스트"
  value       = try(module.vpc.r_private_subnets_ids,"")
}

output "r_public_subnets_ids" {
  description = "Public Subnet ID 리스트"
  value       = try(module.vpc.r_public_subnets_ids,"")
}


output "db_subnet_group_id" {
  description = "The db subnet group name"
  value       = try(module.vpc.db_subnet_group_id, "")
}

output "redis_subnet_group_id" {
  description = "The db subnet group name"
  value       = try(module.vpc.redis_subnet_group_id, "")
}

output "q_redis_subnet_group_id" {
  description = "The db subnet group name"
  value       = try(module.vpc.q_redis_subnet_group_id, "")
}

output "q_aws_db_subnet_group_ids" {
  description = "Database Subnet Group ID ID 리스트"
  value       = try(module.vpc.q_aws_db_subnet_group_ids, "")
}

output "q_subnets_ids" {
  description = "Database Subnet Group ID ID 리스트"
  value       = try(module.vpc.q_subnets_ids,"")
}

output "m_subnets_ids" {
  description = "Database Subnet Group ID ID 리스트"
  value       = module.vpc.m_subnets_ids
}

# route tables
output "public_route_table_ids" {
  description = "Public Route Table ID 리스트"
  value       = try(module.vpc.public_route_table_ids, "")
}

output "private_route_table_ids" {
  description = "Private Route Table ID 리스트"
  value       = try(module.vpc.private_route_table_ids, "")
}

output "m_route_table_ids" {
  description = "Private Route Table ID 리스트"
  value       = try(module.vpc.m_route_table_ids, "")
}

output "q_route_table_ids" {
  description = "Private Route Table ID 리스트"
  value       = try(module.vpc.q_route_table_ids, "")
}

# # NAT gateway

output "nat_ids" {
  description = "NAT Gateway에 할당된 EIP ID 리스트"
  value       = module.vpc.nat_ids
}

output "nat_public_ips" {
  description = "NAT Gateway에 할당된 EIP 리스트"
  value       = module.vpc.nat_public_ips
}

output "natgw_ids" {
  description = "NAT Gateway ID 리스트"
  value       = module.vpc.natgw_ids
}




output "rds_pg_57_id" {
  description = "rds mysql 5.7 parameter group"
  value = module.rds.aurora_param_mysql57_id[0].id
}

output "rds_cluster_pg_57_id" {
  description = "rds mysql 5.7 Cluster parameter group"
  value = module.rds.aurora_cluster_param_mysql57_id[0].id
}