variable "aliases" {
  description = "List of alternate domain names for CloudFront distribution"
  type        = list(string)
  default     = ["web.dev.test.com"]
}

variable "origin_domain_name" {
  description = "Domain name of the origin"
  default     = ${origin_domain}
}

variable "http_port" {
  description = "HTTP port for the custom origin"
  default     = 12013
}

variable "https_port" {
  description = "HTTPS port for the custom origin"
  default     = 12013
}

variable "acm_certificate_arn" {
  description = "ARN of the ACM certificate"
  default     = ${acm_id}
}