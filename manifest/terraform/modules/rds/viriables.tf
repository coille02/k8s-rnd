variable "create_prod_vpc" {
  description = "모듈에서 정의하는 모든 리소스 이름의 prefix"
  type        = bool
  default     = false
}

variable "create_dev_vpc" {
  description = "모듈에서 정의하는 모든 리소스 이름의 prefix"
  type        = bool
  default     = false
}

variable "prod_region" {
  description = "prod region"
  type        = string
  default     = null
}
variable "dev_region" {
  description = "dev region"
  type        = string
  default     = null
}

variable "manage_region" {
  description = "dev region"
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

variable "game_code" {
  description = "모듈에서 정의하는 모든 리소스 이름의 prefix"
}

variable "name" {
  description = "Name of the parameter group"
}

variable "family" {
  description = "The family of the parameter group"
}
