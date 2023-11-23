provider "aws" {
  region = "${local.region}"
}

data "aws_availability_zones" "available" {}

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

# data.terraform_remote_state.cloudfront.outputs.cloudfront_domain_name

locals {
  # remote data aws_data
  tags = data.terraform_remote_state.aws_data.outputs.db_tags
  env_gamecd           = data.terraform_remote_state.aws_data.outputs.env_gamecd
  region               = data.terraform_remote_state.aws_data.outputs.region
  rg_alias             = data.terraform_remote_state.aws_data.outputs.rg_alias
  master_username      = data.terraform_remote_state.aws_data.outputs.lg_user
  master_password      = data.terraform_remote_state.aws_data.outputs.lg_passwd
  sg_id                = data.terraform_remote_state.aws_data.outputs.r_sg_list["r-rnd-kr-rds"].id

  # remote data vpc
  vpc_id               = data.terraform_remote_state.vpc.outputs.vpc_id
  db_subnet_group_name = data.terraform_remote_state.vpc.outputs.db_subnet_group_id
  
  # local data
  worlddb_name = "world"
  gmaedb_name1 = "gamedb-01"
  gmaedb_name2 = "gamedb-02"



  worlddb_tags = {
    Group     = "WorldDB"
  }

  user_eventdb_tags = {
    Group     = "GameDB"
  }

  replicas = {
    aurora_world = {
      name            = "${local.env_gamecd}-${local.rg_alias}-${local.worlddb_name}"
      engine          = "aurora-mysql"
      engine_version  = "5.7"
      master_username = local.master_username
      master_password = local.master_password
      backup_retention_period = 35
      
      instances = {
        1 = {
          identifier          = "${local.env_gamecd}-${local.rg_alias}-${local.worlddb_name}-instance-a"
          availability_zones = "${local.region}a"
          auto_minor_version_upgrade = false
          performance_insights_enabled = true
          instance_class      = "db.r6g.xlarge"
          publicly_accessible = false
        },
        2 = {
          identifier          = "${local.env_gamecd}-${local.rg_alias}-${local.worlddb_name}-instance-c"
          availability_zones = "${local.region}c"
          auto_minor_version_upgrade = false
          performance_insights_enabled = true
          instance_class      = "db.r6g.xlarge"
          publicly_accessible = false
        }
      }

      vpc_id               = local.vpc_id
      db_subnet_group_name = local.db_subnet_group_name
      vpc_security_group_ids = [local.sg_id]

      apply_immediately   = true
      skip_final_snapshot = true

      create_db_cluster_parameter_group = false
      db_cluster_parameter_group_name   = "${local.env_gamecd}-aurora-param-cluster-mysql57"
      db_cluster_parameter_group_family = "aurora-mysql5.7"
      create_db_parameter_group         = false
      db_parameter_group_name           = "${local.env_gamecd}-aurora-mysql57"
      db_parameter_group_family         = "aurora-mysql5.7"
      monitoring_interval             = 60
      monitoring_role_arn = "arn:aws:iam::${account_id}:role/rds-monitoring-role"

      enabled_cloudwatch_logs_exports = ["audit", "error", "slowquery"]

      tags = local.worlddb_tags
    },
    aurora_user_event1 = {
      name            = "${local.env_gamecd}-${local.rg_alias}-${local.gmaedb_name1}"
      engine          = "aurora-mysql"
      engine_version  = "5.7"
      master_username = local.master_username
      master_password = local.master_password
      backup_retention_period = 35
      
      instances = {
        1 = {
          identifier          = "${local.env_gamecd}-${local.rg_alias}-${local.gmaedb_name1}-instance-a"
          availability_zones = "${local.region}a"
          auto_minor_version_upgrade = false
          performance_insights_enabled = true
          instance_class      = "db.r6g.xlarge"
          publicly_accessible = false
        },
        2 = {
          identifier          = "${local.env_gamecd}-${local.rg_alias}-${local.gmaedb_name1}-instance-c"
          availability_zones = "${local.region}c"
          auto_minor_version_upgrade = false
          performance_insights_enabled = true
          instance_class      = "db.r6g.xlarge"
          publicly_accessible = false
        }
      }

      vpc_id               = local.vpc_id
      db_subnet_group_name = local.db_subnet_group_name
      vpc_security_group_ids = [local.sg_id]

      apply_immediately   = true
      skip_final_snapshot = true

      create_db_cluster_parameter_group = false
      db_cluster_parameter_group_name   = "${local.env_gamecd}-aurora-param-cluster-mysql57"
      db_cluster_parameter_group_family = "aurora-mysql5.7"
      create_db_parameter_group         = false
      db_parameter_group_name           = "${local.env_gamecd}-aurora-mysql57"
      db_parameter_group_family         = "aurora-mysql5.7"
      monitoring_interval             = 60
      monitoring_role_arn = "arn:aws:iam::${account_id}:role/rds-monitoring-role"

      enabled_cloudwatch_logs_exports = ["audit", "error", "slowquery"]

      tags = local.user_eventdb_tags
    },
    aurora_user_event2 = {
      name            = "${local.env_gamecd}-${local.rg_alias}-${local.gmaedb_name2}"
      engine          = "aurora-mysql"
      engine_version  = "5.7"
      master_username = local.master_username
      master_password = local.master_password
      backup_retention_period = 35
      
      instances = {
        1 = {
          identifier          = "${local.env_gamecd}-${local.rg_alias}-${local.gmaedb_name2}-instance-a"
          availability_zones = "${local.region}a"
          auto_minor_version_upgrade = false
          performance_insights_enabled = true
          instance_class      = "db.r6g.xlarge"
          publicly_accessible = false
        },
        2 = {
          identifier          = "${local.env_gamecd}-${local.rg_alias}-${local.gmaedb_name2}-instance-c"
          availability_zones = "${local.region}c"
          auto_minor_version_upgrade = false
          performance_insights_enabled = true
          instance_class      = "db.r6g.xlarge"
          publicly_accessible = false
        }
      }

      vpc_id               = local.vpc_id
      db_subnet_group_name = local.db_subnet_group_name
      vpc_security_group_ids = [local.sg_id]

      apply_immediately   = true
      skip_final_snapshot = true

      create_db_cluster_parameter_group = false
      db_cluster_parameter_group_name   = "${local.env_gamecd}-aurora-param-cluster-mysql57"
      db_cluster_parameter_group_family = "aurora-mysql5.7"
      create_db_parameter_group         = false
      db_parameter_group_name           = "${local.env_gamecd}-aurora-mysql57"
      db_parameter_group_family         = "aurora-mysql5.7"
      monitoring_interval             = 60
      monitoring_role_arn = "arn:aws:iam::${account_id}:role/rds-monitoring-role"

      enabled_cloudwatch_logs_exports = ["audit", "error", "slowquery"]

      tags = local.user_eventdb_tags
    }
    aurora_user_event3 = {
      name            = "${local.env_gamecd}-${local.rg_alias}-${local.user_eventdb_name3}"
      engine          = "aurora-mysql"
      engine_version  = "5.7"
      master_username = local.master_username
      master_password = local.master_password
      backup_retention_period = 35
      
      instances = {
        1 = {
          identifier          = "${local.env_gamecd}-${local.rg_alias}-${local.user_eventdb_name3}-instance-a"
          availability_zones = "${local.region}a"
          auto_minor_version_upgrade = false
          performance_insights_enabled = true
          instance_class      = "db.r6g.xlarge"
          publicly_accessible = false
        },
        2 = {
          identifier          = "${local.env_gamecd}-${local.rg_alias}-${local.user_eventdb_name3}-instance-c"
          availability_zones = "${local.region}c"
          auto_minor_version_upgrade = false
          performance_insights_enabled = true
          instance_class      = "db.r6g.xlarge"
          publicly_accessible = false
        }
      }

      vpc_id               = local.vpc_id
      db_subnet_group_name = local.db_subnet_group_name
      vpc_security_group_ids = [local.sg_id]

      apply_immediately   = true
      skip_final_snapshot = true

      create_db_cluster_parameter_group = false
      db_cluster_parameter_group_name   = "${local.env_gamecd}-aurora-param-cluster-mysql57"
      db_cluster_parameter_group_family = "aurora-mysql5.7"
      create_db_parameter_group         = false
      db_parameter_group_name           = "${local.env_gamecd}-aurora-mysql57"
      db_parameter_group_family         = "aurora-mysql5.7"
      monitoring_interval             = 60
      monitoring_role_arn = "arn:aws:iam::${account_id}:role/rds-monitoring-role"

      enabled_cloudwatch_logs_exports = ["audit", "error", "slowquery"]

      tags = local.user_eventdb_tags
    },
    aurora_user_event4 = {
      name            = "${local.env_gamecd}-${local.rg_alias}-${local.user_eventdb_name4}"
      engine          = "aurora-mysql"
      engine_version  = "5.7"
      master_username = local.master_username
      master_password = local.master_password
      backup_retention_period = 35
      

      instances = {
        1 = {
          identifier          = "${local.env_gamecd}-${local.rg_alias}-${local.user_eventdb_name4}-instance-a"
          availability_zones = "${local.region}a"
          auto_minor_version_upgrade = false
          performance_insights_enabled = true
          instance_class      = "db.r6g.xlarge"
          publicly_accessible = false
        },
        2 = {
          identifier          = "${local.env_gamecd}-${local.rg_alias}-${local.user_eventdb_name4}-instance-c"
          availability_zones = "${local.region}c"
          auto_minor_version_upgrade = false
          performance_insights_enabled = true
          instance_class      = "db.r6g.xlarge"
          publicly_accessible = false
        }
      }

      vpc_id               = local.vpc_id
      db_subnet_group_name = local.db_subnet_group_name
      vpc_security_group_ids = [local.sg_id]

      apply_immediately   = true
      skip_final_snapshot = true

      create_db_cluster_parameter_group = false
      db_cluster_parameter_group_name   = "${local.env_gamecd}-aurora-param-cluster-mysql57"
      db_cluster_parameter_group_family = "aurora-mysql5.7"
      create_db_parameter_group         = false
      db_parameter_group_name           = "${local.env_gamecd}-aurora-mysql57"
      db_parameter_group_family         = "aurora-mysql5.7"
      monitoring_interval             = 60
      monitoring_role_arn = "arn:aws:iam::${account_id}:role/rds-monitoring-role"

      enabled_cloudwatch_logs_exports = ["audit", "error", "slowquery"]

      tags = local.user_eventdb_tags
    }
  }
}

module "rds" {
  source = "terraform-aws-modules/rds-aurora/aws"

  for_each = local.replicas

  name = each.value.name
  engine          = each.value.engine
  engine_version  = each.value.engine_version
  master_username = each.value.master_username
  master_password = each.value.master_password
  backup_retention_period = each.value.backup_retention_period
  instances = each.value.instances
  vpc_id               = each.value.vpc_id
  db_subnet_group_name = each.value.db_subnet_group_name
  vpc_security_group_ids = each.value.vpc_security_group_ids
  apply_immediately   = each.value.apply_immediately
  skip_final_snapshot = each.value.skip_final_snapshot
  create_security_group  = false
  create_monitoring_role = false
  create_db_cluster_parameter_group = each.value.create_db_cluster_parameter_group
  db_cluster_parameter_group_name   = each.value.db_cluster_parameter_group_name
  db_cluster_parameter_group_family = each.value.db_cluster_parameter_group_family
  create_db_parameter_group         = each.value.create_db_parameter_group
  db_parameter_group_name           = each.value.db_parameter_group_name
  db_parameter_group_family         = each.value.db_parameter_group_family
  monitoring_interval             = each.value.monitoring_interval
  monitoring_role_arn = each.value.monitoring_role_arn
  enabled_cloudwatch_logs_exports = each.value.enabled_cloudwatch_logs_exports
  tags                       = merge(local.tags, try(each.value.tags, {}))
  manage_master_user_password = false
  deletion_protection = true
}

