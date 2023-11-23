output "dev_aurora_param_mysql57_id" {
  value = aws_db_parameter_group.dev-aurora-param-mysql57[*]
}

output "dev_aurora_cluster_param_mysql57_id" {
  value = aws_rds_cluster_parameter_group.dev-aurora-param-cluster-mysql57[*]
}

output "aurora_param_mysql57_id" {
  value = aws_db_parameter_group.aurora-param-mysql57[*]
}

output "aurora_cluster_param_mysql57_id" {
  value = aws_rds_cluster_parameter_group.aurora-param-cluster-mysql57[*]
}

