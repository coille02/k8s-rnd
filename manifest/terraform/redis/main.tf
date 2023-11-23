data "terraform_remote_state" "aws_data" {
  backend = "s3"
  config = {
    bucket = "r-rnd-terraform"
    key    = "awsdata/terraform.tfstate"
    region = "ap-northeast-2"
  }
}

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "r-rnd-terraform"
    key    = "vpc/terraform.tfstate"
    region = "ap-northeast-2"
  }
}

locals {
  # remote data aws_data
  tags = data.terraform_remote_state.aws_data.outputs.db_tags
  env_gamecd = data.terraform_remote_state.aws_data.outputs.env_gamecd
  rg_alias = data.terraform_remote_state.aws_data.outputs.rg_alias
  sg_id = data.terraform_remote_state.aws_data.outputs.r_sg_list["r-rnd-kr-redis"].id

  # remote data vpc
  redis_sn_group = data.terraform_remote_state.vpc.outputs.redis_subnet_group_id

  # local data
  world-redis-tags = {
    Group     = "World_Redis"
  }

  user-redis-tags = {
    Group     = "Game_Redis"
  }

  replicas = {
    world-redis = {
      replication_group_id       = "${local.env_gamecd}-${local.rg_alias}-redis-world"
      description                = "${local.env_gamecd}-${local.rg_alias}-redis-world-terraform"
      subnet_group_name          = local.redis_sn_group
      security_group_ids         = [local.sg_id]
      engine                     = "redis"
      engine_version             = "7.0"
      instance_type              = "cache.r6g.large"
      port                       = 6379
      parameter_group_name       = aws_elasticache_parameter_group.r-rnd-redis-7.name
      automatic_failover_enabled = true
      num_cache_clusters         = 2
      multi_az_enabled           = true
      auto_minor_version_upgrade = false
      tags = local.world-redis-tags
    },
    game-redis = {
      replication_group_id       = "${local.env_gamecd}-${local.rg_alias}-redis-game"
      description                = "${local.env_gamecd}-${local.rg_alias}-redis-user-terraform"
      subnet_group_name          = local.redis_sn_group
      security_group_ids         = [local.sg_id]
      engine                     = "redis"
      engine_version             = "7.0"
      instance_type              = "cache.r6g.large"
      port                       = 6379
      parameter_group_name       = aws_elasticache_parameter_group.r-rnd-redis-7.name
      automatic_failover_enabled = true
      num_cache_clusters         = 2
      multi_az_enabled           = true
      auto_minor_version_upgrade = false
      tags = local.user-redis-tags
    }
  }
}

resource "aws_elasticache_parameter_group" "r-rnd-redis-7" {
  name   = "${local.env_gamecd}-redis-7x"
  family = "redis7"

  parameter {
    name  = "databases"
    value = "26"
  }
}

module "redis" {
  source = "github.com/coille02/terraform-aws-redis.git"

  for_each = local.replicas

  replication_group_id       = each.value.replication_group_id
  description                = each.value.description
  subnet_group_name          = each.value.subnet_group_name
  security_group_ids         = each.value.security_group_ids
  engine                     = each.value.engine
  engine_version             = each.value.engine_version
  instance_type              = each.value.instance_type
  port                       = each.value.port
  parameter_group_name       = each.value.parameter_group_name
  automatic_failover_enabled = each.value.automatic_failover_enabled
  num_cache_clusters         = each.value.num_cache_clusters
  multi_az_enabled           = each.value.multi_az_enabled
  auto_minor_version_upgrade = each.value.auto_minor_version_upgrade
  tags                       = merge(local.tags, try(each.value.tags, {}))
}