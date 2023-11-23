# Route53

data "terraform_remote_state" "cloudfront" {
  backend = "s3"
  config = {
    bucket = "r-rnd-terraform"
    key    = "cf/terraform.tfstate"
    region = "ap-northeast-2"
  }
}

data "terraform_remote_state" "aws_data" {
  backend = "s3"
  config = {
    bucket = "r-rnd-terraform"
    key    = "awsdata/terraform.tfstate"
    region = "ap-northeast-2"
  }
}

data "terraform_remote_state" "rds" {
  backend = "s3"
  config = {
    bucket = "r-rnd-terraform"
    key    = "rds/terraform.tfstate"
    region = "ap-northeast-2"
  }
}

data "terraform_remote_state" "redis" {
  backend = "s3"
  config = {
    bucket = "r-rnd-terraform"
    key    = "redis/terraform.tfstate"
    region = "ap-northeast-2"
  }
}

locals {
  env          = "r"
  rg_alias     = data.terraform_remote_state.aws_data.outputs.rg_alias
}

module "route53_records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "2.10.2"
  zone_name = data.terraform_remote_state.aws_data.outputs.public_zone_name

  records = [
    {
      name = "web"
      type = "A"
      alias = {
        name                   = data.terraform_remote_state.cloudfront.outputs.cloudfront_domain_name
        zone_id                = data.terraform_remote_state.cloudfront.outputs.cloudfront_hosted_zone_id
        evaluate_target_health = false
      }
    },
    {
      name = "dev-web"
      type = "A"
      alias = {
        name                   = data.terraform_remote_state.cloudfront.outputs.cloudfront_domain_name
        zone_id                = data.terraform_remote_state.cloudfront.outputs.cloudfront_hosted_zone_id
        evaluate_target_health = false
      }
    }
  ]
}

module "route53_records_private" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "2.10.2"
  zone_name = data.terraform_remote_state.aws_data.outputs.internal_zone_name
  private_zone = true

  records = [
    {
      name = "${local.env}-${local.rg_alias}-gamedb-01"
      type = "CNAME"
      ttl     = 300
      records = [data.terraform_remote_state.rds.outputs.rds_clusters[0]["cluster_endpoint"]]
    },
    {
      name = "${local.env}-${local.rg_alias}-gamedb-02"
      type = "CNAME"
      ttl     = 300
      records = [data.terraform_remote_state.rds.outputs.rds_clusters[1]["cluster_endpoint"]]
    },
    {
      name = "${local.env}-${local.rg_alias}-worlddb"
      type = "CNAME"
      ttl     = 300
      records = [data.terraform_remote_state.rds.outputs.rds_clusters[4]["cluster_endpoint"]]
    },
    {
      name = "${local.env}-${local.rg_alias}-game-redis"
      type = "CNAME"
      ttl     = 300
      records = [data.terraform_remote_state.redis.outputs.redis_clusters[0]["cluster_endpoint"]]
    },
    {
      name = "${local.env}-${local.rg_alias}-world-redis"
      type = "CNAME"
      ttl     = 300
      records = [data.terraform_remote_state.redis.outputs.redis_clusters[1]["cluster_endpoint"]]
    }
  ]
}
