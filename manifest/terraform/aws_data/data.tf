provider "aws" {
  alias = "ap-northeast-2"

  region = "ap-northeast-2"
}

provider "aws" {
  alias = "us"

  region = "us-east-1"
}

# vpc 

data "aws_vpc" "prod-vpc" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

data "aws_vpc" "manage-vpc" {
  provider = aws.ap-northeast-2
  filter {
    name   = "tag:Name"
    values = [var.manage_vpc_name]
  }
}

data "aws_subnets" "prod_private_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.prod-vpc.id]
  }

  filter {
    name   = "tag:subnet"
    values = ["prod-sn-private"]
  }
}

data "aws_subnets" "prod_public_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.prod-vpc.id]
  }

  filter {
    name   = "tag:subnet"
    values = ["prod-sn-public"]
  }
}

# Security group

data "aws_security_groups" "prod_sg_list" {
  filter {
    name = "vpc-id"
    values = [data.aws_vpc.prod-vpc.id]
  }
}

data "aws_security_group" "prod_sg_details" {
  foprod_each = toset(data.aws_security_groups.prod_sg_list.ids)
  id       = each.value
}

# rds

data "aws_db_subnet_group" "rds_subnet_group" {
    name = "prod-sn-db-rnd"
}

# Elasticache

data "aws_elasticache_subnet_group" "redis_subnet_group" {
    name = "prod-sn-redis-rnd"
}


# ec2 ami

data "aws_ami" "amazon_linux2" {
  most_recent = true
  owners      = [${account_id}] # Amazon owners

  filter {
    name   = "name"       #이름으로 필터, admin, config .. 등등 서버 ami 추가 되면 세트로 추가해야함
    values = ["amzn2-5x-ami-hvm-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

}

# route53

data "aws_route53_zone" "internal_zone" {
  name         = var.zone_name
  private_zone = true
}

data "aws_route53_zone" "public_zone" {
  name         = var.public_zone_name
  private_zone = false
}

# elb

data "aws_lb_hosted_zone_id" "alb_zone_id" {
  load_balanceprod_type = "application"
}

data "aws_lb_hosted_zone_id" "nlb_zone_id" {
  load_balanceprod_type = "network"
}


data "aws_lb" "lb_dns_name" {
  # name = "manage-alb-rnd"
  name = var.lb_name
}

# acm

data "aws_acm_certificate" "rnd_acm_arn" {
  provider    = aws.us
  domain      = "*.test.com"
  most_recent = true
}

# sns

data "aws_sns_topic" "TechPmanage_CloudWatch_Alarm" {
  name = "TechPmanage-CloudWatch-Alram"
}


# VPC
output "vpc_id" {
  description = "VPC ID"
  value       = try(data.aws_vpc.prod-vpc.id,"")
}

output "manage_vpc_id" {
  description = "manage VPC ID"
  value       = try(data.aws_vpc.manage-vpc.id,"")
}

output "vpc_cidprod_block" {
  description = "VPC CIDR BLOCK"
  value       = try(data.aws_vpc.prod-vpc.cidprod_block,"")
}


output "manage_vpc_cidprod_block" {
  description = "manage-VPC CIDR BLOCK"
  value       = try(data.aws_vpc.manage-vpc.cidprod_block,"")
}

output "prod_private_subnets_ids" {
  description  = "Private Subnet ID 리스트"
  value        = try(data.aws_subnets.prod_private_subnets.ids,"")
}

output "prod_private_subnets_ids_a" {
  description  = "Private Subnet ID 리스트"
  value        = try(data.aws_subnets.prod_private_subnets.ids[0],"")
}

output "prod_private_subnets_ids_c" {
  description  = "Private Subnet ID 리스트"
  value        = try(data.aws_subnets.prod_private_subnets.ids[1],"")
}


output "prod_public_subnets_ids" {
  description  = "Public Subnet ID 리스트"
  value        = try(data.aws_subnets.prod_public_subnets.ids,"")
}

output "prod_public_subnets_ids_a" {
  description  = "Public Subnet ID 리스트"
  value        = try(data.aws_subnets.prod_public_subnets.ids[0],"")
}

output "prod_public_subnets_ids_c" {
  description  = "Public Subnet ID 리스트"
  value        = try(data.aws_subnets.prod_public_subnets.ids[1],"")
}

# Security group

output "prod_sg_list" {
  value = { for sg in data.aws_security_group.prod_sg_details : sg.name => sg}
}


# RDS

output "aws_db_subnet_group" {
  description  = "rds subnet group"
  value        = try(data.aws_db_subnet_group.rds_subnet_group,"")
}

output "prod_db_subnets_ids" {
  description  = "Public Subnet ID 리스트"
  value        = try(data.aws_db_subnet_group.rds_subnet_group.subnet_ids,"")
}

# Elasticache

output "prod_redis_subnet_group_name" {
  description = "Elasticache subnet"
  value       = try(data.aws_elasticache_subnet_group.redis_subnet_group.name,"")
}

# ec2 ami

output "amazon_linux2" {
  description  = "amzn2 Clean-Up Image"
  value        = try(data.aws_ami.amazon_linux2.id,"")
}

# route53

output "internal_zone_id" {
  description = "Internal Zone ID"
  value       = try(data.aws_route53_zone.internal_zone.id,"")
}

output "internal_zone_name" {
  description = "Internal Zone name"
  value       = try(data.aws_route53_zone.internal_zone.name,"")
}

output "public_zone_name" {
  description = "Public Zone name"
  value       = try(data.aws_route53_zone.public_zone.name, "")
}

# elb

output "lb_dns_name" {
  description = "lb_dns_name"
  value       = try(data.aws_lb.lb_dns_name.dns_name, "")
}

output "nlb_zone_id" {
  description = "nlb_zone_id"
  value       = try(data.aws_lb_hosted_zone_id.nlb_zone_id, "")
}

# output "alb_zone_id" {
#   description = "alb_zone_id"
#   value       = try(data.aws_lb_hosted_zone_id.alb_zone_id, "")
# }

output "alb_zone_id" {
  description = "alb_zone_id"
  value       = lookup(data.aws_lb_hosted_zone_id.alb_zone_id, "id", null)
}

# acm

output "rnd_acm_arn" {
  description = "rnd_acm_arn"
  value       = try(data.aws_acm_certificate.rnd_acm_arn.arn, "")
}

# sns

output "TechPmanage_CloudWatch_Alarm" {
  description = "TechPmanage_CloudWatch_Alarm"
  value       = try(data.aws_sns_topic.TechPmanage_CloudWatch_Alarm.arn, "")
}

# common

output "env" {
  description = "Deploy dev/prod Env"
  value       = "${local.env}"
}

output "gamecd" {
  description = "game service code"
  value       = "${local.gamecd}"
}

output "env_gamecd" {
  description = "env-gamecd"
  value       = "${local.env_gamecd}"
}

output "db_tags" {
  description = "DB ISMS Tags"
  value       = "${local.isms_db_tags}"
}

output "s3_tags" {
  description = "s3 ISMS Tags"
  value       = "${local.isms_s3_tags}"
}

output "ec2_tags" {
  description = "ec2 ISMS Tags"
  value       = "${local.isms_ec2_tags}"
}

output "region" {
  description = "deploy region"
  value = "${local.region}"
}

output "rg_alias" {
  description = "deploy region alias"
  value = "${local.rg_alias}"
}

output "rnd_user" {
  description = "admin user default name"
  value = "${local.admin_username}"
}

output "rnd_passwd" {
  description = "admin user default password"
  value = "${local.admin_password}"
}

locals {
  admin_username = ${rds_admin}
  admin_password = ${rds_passwd}
  env = "prod"
  gamecd = "rnd"
  region = "ap-northeast-2"
  rg_alias =  (local.region == "ap-northeast-2" ? "kr":
            local.region == "ap-northeast-1" ? "jp":
            local.region == "ap-southeast-1" ? "sg":
            local.region == "eu-central-1" ? "de":
            local.region == "us-east-1" ? "us":
            "kr")
  env_gamecd = (local.env == "prod" ? "prod-${local.gamecd}" : 
                local.env == "dev" ? "dev-${local.gamecd}" :
                local.env == "stage" ? "stage-${local.gamecd}" :
                local.gamecd)

  owner = "Infra"
  user = "coille02"

  isms_db_tags = {
      gamecode = local.gamecd
      Env = local.env
      Group = ""
      "S.Owner" = local.owner
      Security = "2/2/2/2"
      User = local.user
  }

  isms_s3_tags = {
      gamecode = local.gamecd
      Env = local.env
      Group = ""
      "S.Owner" = local.owner
      Security = "2/1/1/3"
      User = local.user
  }

  isms_ec2_tags = {
      gamecode = local.gamecd
      Env = local.env
      Group = ""
      Name = ""
      "S.App" = ""
      "S.OS" = ""
      "S.Owner" = local.owner
      Security = "2/1/1/3"
      User = local.user
  }
}

variable "manage_vpc_name" {
  description = "manage_vpc_name"
  default     = "manage-vpc-rnd-kr"
}

variable "vpc_name" {
  description = "prod-vpc-rnd-kr"
  default     = "prod-vpc-rnd-kr"
}

variable "zone_name" {
  description = ""
  default     = "rnd.internal"
}

variable "public_zone_name" {
  description = ""
  default = "test.com"
}

variable "lb_name" {
  type    = string
  default = "rnd-kr-web-alb"
}