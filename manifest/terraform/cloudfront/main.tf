# CloudFront

data "terraform_remote_state" "aws_data" {
  backend = "s3"
  config = {
    bucket = "r-rnd-terraform"
    key    = "awsdata/terraform.tfstate"
    region = "ap-northeast-2"
  }
}


module "cloudfront" {
  source = "terraform-aws-modules/cloudfront/aws"
  # version = "3.2.1"

  aliases = ["web.test.com", "web.dev.test.com"]

  comment = "Cloudfront for ALB rnd WEB"
  enabled = true

  origin = {
    rnd-web-alb = {
      domain_name = data.terraform_remote_state.aws_data.outputs.lb_dns_name
      custom_origin_config = {
        http_port              = 80
        https_port             = 80
        origin_protocol_policy = "http-only"
        origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
      }
    }
  }

  # SSL Configuration
  viewer_certificate = {
    acm_certificate_arn      = data.terraform_remote_state.aws_data.outputs.rnd_acm_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  # Cache behaviour
  default_cache_behavior = {
    target_origin_id       = "rnd-web-alb"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods         = ["GET", "HEAD", "OPTIONS"]
    compress               = false
    query_string           = false
  }
}
