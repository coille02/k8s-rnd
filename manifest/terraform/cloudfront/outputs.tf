output "cloudfront_domain_name" {
  description = "The domain name corresponding to the CloudFront distribution"
  value       = module.cloudfront.cloudfront_distribution_domain_name
}

output "cloudfront_hosted_zone_id" {
  description = "The domain name corresponding to the CloudFront distribution"
  value       = module.cloudfront.cloudfront_distribution_hosted_zone_id
}
