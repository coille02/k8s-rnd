# VPC 는 허락받고 건드세요

locals {
  # VPC 생성 여부 결정
  create_prod_vpc       = true
  create_manage_vpc       = false
  create_dev_vpc       = false
  create_manage_to_prod_peer = true

  # Peering 생성 여부 결정
  # create_manage_vpc && create_dev_vpc 이면 manage_q peering 자동생성
  # create_manage_vpc && create_prod_vpc 이면 manage_r peering 자동생성

  # 환경 설정
  game_code  = "rnd"
  country    = "kr"
  aws_region = "ap-northeast-2"

  # VPC CIDR 입력
  prod_cidr = "10.0.0.0/16"
  dev_cidr = "10.1.0.0/23"
  manage_cidr = "10.1.2.0/23"

  # VPC의 prod Public Subnet CIDR block을 정의한다.
  prod_public_subnets = ["10.0.0.0/18", "10.0.64.0/18"]

  # VPC의 prod Private Subnet CIDR block을 정의한다.
  prod_private_subnets = ["10.0.128.0/18", "10.0.192.0/18"]

  # VPC의 dev Subnet CIDR block을 정의한다.
  dev_public_subnets = ["10.1.0.0/24", "10.1.1.0/24"]

  # VPC의 Manage Subnet CIDR block을 정의한다.
  manage_public_subnets = ["10.1.2.0/24", "10.1.3.0/24"]

  # dev 계정을 생성할경우만 변경하여 입력
  # dev 생성시 계정이 말료되어 에러가 나면 새로 교체 진행
  # 생성을 안하더라도 값은 있어야하니 삭제 금지.
  dev_owneprod_id      = ${account_id}
  dev_access_key    = ${dev_access_key}
  dev_secret_key    = ${dev_secret_key}
  dev_session_token = ${dev_session_token}



  # 이후 아래값은 수정하지 않음---------------------------------------------
  dev_game_code = local.game_code
  manage_game_code = local.game_code
  prod_game_code = local.game_code
  manage_region    = "ap-northeast-2"
  dev_region    = local.aws_region
  prod_region    = local.aws_region
}

module "vpc" {
  source = "../modules/vpc"

  create_prod_vpc       = local.create_prod_vpc
  create_manage_vpc       = local.create_manage_vpc
  create_dev_vpc       = local.create_dev_vpc
  create_manage_to_prod_peer = local.create_manage_to_prod_peer
  game_code          = local.game_code
  region             = local.country
  prod_cidr             = local.prod_cidr
  dev_cidr             = local.dev_cidr
  manage_cidr             = local.manage_cidr
  azs                = ["${local.aws_region}a", "${local.aws_region}c"]
  prod_public_subnets   = local.prod_public_subnets
  prod_private_subnets  = local.prod_private_subnets
  dev_public_subnets   = local.dev_public_subnets
  manage_public_subnets   = local.manage_public_subnets
  dev_owneprod_id         = local.dev_owneprod_id
  dev_access_key       = local.dev_access_key
  dev_secret_key       = local.dev_secret_key
  dev_session_token    = local.dev_session_token
  dev_game_code        = local.dev_game_code
  manage_game_code        = local.manage_game_code
  prod_game_code        = local.prod_game_code
  dev_region           = local.dev_region
  manage_region           = local.manage_region
  prod_region           = local.prod_region

  tags = {
    "TerraformManaged" = "true"
  }
}

module "rds" {
  source = "../modules/rds"

  #DB parameter group
  create_prod_vpc    = local.create_prod_vpc
  create_dev_vpc    = local.create_dev_vpc
  dev_access_key    = local.dev_access_key
  dev_secret_key    = local.dev_secret_key
  dev_session_token = local.dev_session_token
  dev_region        = local.dev_region
  manage_region        = local.manage_region
  prod_region        = local.prod_region

  game_code = local.game_code
  name      = local.game_code
  family    = "aurora5.7" # 변경하지 않는다.
}


