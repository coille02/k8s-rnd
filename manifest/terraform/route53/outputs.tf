output "route53_record_name" {
    description = "The name of the record"
    value       = module.route53_records.route53_record_name
}

output "private_route53_record_name" {
    description = "The name of the record"
    value       = module.route53_records_private.route53_record_name
}