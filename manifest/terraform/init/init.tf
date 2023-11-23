# 1회성 스크립트로 기존 생성되어있는 s3 dynamodb는 삭제되지 않으니 참고해주세요
locals {
  owner             = "Infra"
  user              = "coille02"
  gamecd            = "rnd"
  env               = "r"
  dynamo_table_name = "terraform-lock"
  billing_mode      = "PAY_PER_REQUEST"
  attribute_name    = "LockID"
  attribute_type    = "S"
  tags = {
    gamecode  = local.gamecd
    Env       = local.env
    Group     = ""
    "S.Owner" = local.owner
    Security  = "2/1/1/3"
    User      = local.user
  }

  r-terraform-tags = {
    Group = "prod terraform state bucket"
  }

  s3_lists = {
    r-terraform-backend = {
      bucket_name   = "r-rnd-terraform"
      force_destroy = true
      versioning    = { enabled = true }
      tags          = local.r-terraform-tags
    }
  }
  dynamodb_list = {
    c-eks = {
      name         = "c-rnd-${local.dynamo_table_name}-eks"
      billing_mode = local.billing_mode
      hash_key     = local.attribute_name
      attribute = {
        name = local.attribute_name
        type = local.attribute_type
      }
    },
    eks = {
      name         = "r-rnd-${local.dynamo_table_name}-eks"
      billing_mode = local.billing_mode
      hash_key     = local.attribute_name
      attribute = {
        name = local.attribute_name
        type = local.attribute_type
      }
    },
    route53 = {
      name         = "r-rnd-${local.dynamo_table_name}-route53"
      billing_mode = local.billing_mode
      hash_key     = local.attribute_name
      attribute = {
        name = local.attribute_name
        type = local.attribute_type
      }
    },
    elasticahce = {
      name         = "r-rnd-${local.dynamo_table_name}-elasticache"
      billing_mode = local.billing_mode
      hash_key     = local.attribute_name
      attribute = {
        name = local.attribute_name
        type = local.attribute_type
      }
    },
    rds = {
      name         = "r-rnd-${local.dynamo_table_name}-rds"
      billing_mode = local.billing_mode
      hash_key     = local.attribute_name
      attribute = {
        name = local.attribute_name
        type = local.attribute_type
      }
    },
    vpc = {
      name         = "r-rnd-${local.dynamo_table_name}-vpc"
      billing_mode = local.billing_mode
      hash_key     = local.attribute_name
      attribute = {
        name = local.attribute_name
        type = local.attribute_type
      }
    },
    cf = {
      name         = "r-rnd-${local.dynamo_table_name}-cf"
      billing_mode = local.billing_mode
      hash_key     = local.attribute_name
      attribute = {
        name = local.attribute_name
        type = local.attribute_type
      }
    },
    ec2 = {
      name         = "r-rnd-${local.dynamo_table_name}-ec2"
      billing_mode = local.billing_mode
      hash_key     = local.attribute_name
      attribute = {
        name = local.attribute_name
        type = local.attribute_type
      }
    },
    awsdata = {
      name         = "r-rnd-${local.dynamo_table_name}-awsdata"
      billing_mode = local.billing_mode
      hash_key     = local.attribute_name
      attribute = {
        name = local.attribute_name
        type = local.attribute_type
      }
    },
  }
}


module "dynamodb_table" {
  source = "terraform-aws-modules/dynamodb-table/aws"

  for_each = local.dynamodb_list

  name         = each.value.name
  billing_mode = each.value.billing_mode
  hash_key     = each.value.hash_key
  attributes   = [each.value.attribute]
}

module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  for_each = local.s3_lists

  bucket        = each.value.bucket_name
  force_destroy = each.value.force_destroy
  versioning    = each.value.versioning
  tags          = merge(local.tags, try(each.value.tags, {}))
}
