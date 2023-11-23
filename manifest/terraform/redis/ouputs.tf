output "redis_clusters" {
  description = "List of maps containing the cluster details for each RDS instance."
  value = [for v in module.redis : {
    cluster_name     = v.name
    cluster_id       = v.id
    cluster_endpoint = v.primary_endpoint
  }]
}

output "r-pg-group" {
  description = "prod parameter group"
  value       = aws_elasticache_parameter_group.r-rnd-redis-7.name
}
