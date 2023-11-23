# variables.tf

variable "create_prod_vpc" {
  description = "모듈에서 정의하는 모든 리소스 이름의 prefix"
  type        = bool
  default     = false
}

variable "create_manage_vpc" {
  description = "모듈에서 정의하는 모든 리소스 이름의 prefix"
  type        = bool
  default     = false
}

variable "create_dev_vpc" {
  description = "모듈에서 정의하는 모든 리소스 이름의 prefix"
  type        = bool
  default     = false
}

variable "create_manage_to_prod_peer" {
  description = "m vpc 와 r vpc peering 여부 선택"
  type        = bool
  default     = false
}

# variable "game_code" {
#   description = "모듈에서 정의하는 모든 리소스 이름의 prefix"
#   type        = string
# }

variable "region" {
  description = "국가코드"
  type        = string
}

variable "manage_vpc_id" {
  description = "manage vpc id"
  type        = string
  default     = "vpc-0ac0fc02193d22675"
}

variable "manage_rtb_id" {
  description = "manage routing table id"
  type        = string
  default     = "rtb-027012c58a99cf4a3"
}

variable "prod_cidr" {
  description = "VPC에 할당한 CIDR block"
  type        = string
  default     = "10.12.0.0/16"
}

variable "dev_cidr" {
  description = "VPC에 할당한 CIDR block"
  type        = string
  default     = "10.47.8.0/23"
}

variable "manage_cidr" {
  description = "VPC에 할당한 CIDR block"
  type        = string
  default     = "10.47.10.0/23"
}

variable "prod_public_subnets" {
  description = "prod Public Subnet IP 리스트"
  type        = list(string)
  default     = ["10.15.2.0/24", "10.15.1.0/24"]
}

variable "dev_public_subnets" {
  description = "DEV Public Subnet IP 리스트"
  type        = list(string)
  default     = ["10.15.2.0/24", "10.15.1.0/24"]
}

variable "manage_public_subnets" {
  description = "Manage Public Subnet IP 리스트"
  type        = list(string)
  default     = ["10.15.2.0/24", "10.15.1.0/24"]
}

variable "prod_private_subnets" {
  description = "prod Private Subnet IP 리스트"
  type        = list(string)
  default     = ["10.15.2.0/24", "10.15.1.0/24"]
}

variable "azs" {
  description = "사용할 availability zones 리스트"
  type        = list(string)
}

variable "tags" {
  description = "모든 리소스에 추가되는 tag 맵"
  type        = map(string)
}

# variable "dev_access_key" {
#   description = "DEV_access_key"
#   type        = string
#   default     = null
# }

# variable "dev_secret_key" {
#   description = "DEV_secret_key"
#   type        = string
#   default     = null
# }

# variable "dev_session_token" {
#   description = "DEV_session_token"
#   type        = string
#   default     = null
# }

# variable "dev_region" {
#   description = "DEV region"
#   type        = string
#   default     = null
# }


#Peering
# variable "create_manage_dev_peering" {
#   description = "create_manage_vpc"
#   type        = bool
#   default     = false
# }

# variable "create_manage_prod_peering" {
#   description = "create_manage_vpc"
#   type        = bool
#   default     = false
# }

# variable "dev_vpc_id" {
#   description = "DEV vpc id"
#   type        = string
#   default     = null
# }
# variable "manage_vpc_id" {
#   description = "manage vpc id"
#   type        = string
#   default     = null
# }
# variable "prod_vpc_id" {
#   description = "prod vpc id"
#   type        = string
#   default     = null
# }

variable "prod_region" {
  description = "prod region"
  type        = string
  default     = null
}
variable "dev_region" {
  description = "DEV region"
  type        = string
  default     = null
}

variable "manage_region" {
  description = "DEV region"
  type        = string
  default     = null
}

variable "aws_region" {
  description = "aws default region"
  type        = string
  default     = null
}

variable "dev_env" {
  description = "DEV env"
  type        = string
  default     = "dev"
}
variable "manage_env" {
  description = "manage env"
  type        = string
  default     = "manage"
}

variable "prod_env" {
  description = "manage env"
  type        = string
  default     = "prod"
}

# variable "manage_route_table_ids" {
#   type = list(string)
# }
# variable "dev_route_table_ids" {
#   type = list(string)
# }

# variable "private_route_table_ids" {
#   type = list(string)
# }

# variable "public_route_table_ids" {
#   type = list(string)
# }

# variable "manage_cidprod_block" {
#   description = "manage env"
#   type        = string
#   default     = null
# }

# variable "dev_cidprod_block" {
#   description = "manage env"
#   type        = string
#   default     = null
# }

# variable "prod_cidprod_block" {
#   description = "manage env"
#   type        = string
#   default     = null
# }

variable "game_code" {
  description = "모듈에서 정의하는 모든 리소스 이름의 prefix"
  type        = string
}

variable "dev_game_code" {
  description = "모듈에서 정의하는 모든 리소스 이름의 prefix"
  type        = string
}

variable "manage_game_code" {
  description = "모듈에서 정의하는 모든 리소스 이름의 prefix"
  type        = string
}
variable "prod_game_code" {
  description = "모듈에서 정의하는 모든 리소스 이름의 prefix"
  type        = string
}

variable "dev_owner_id" {
  description = "accept account id"
  type        = string
  default     = null
}

variable "dev_access_key" {
  description = "accept_access_key"
  type        = string
  default     = null
}

variable "dev_secret_key" {
  description = "accept_secret_key"
  type        = string
  default     = null
}

variable "dev_session_token" {
  description = "accept_session_token"
  type        = string
  default     = null
}
