output "rds_clusters" {
  description = "List of maps containing the cluster details for each RDS instance."
  value = [for v in module.rds : {
    cluster_arn            = v.cluster_arn
    cluster_id             = v.cluster_id
    cluster_endpoint       = v.cluster_endpoint
  }]
}