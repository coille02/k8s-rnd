variable "aws_account_id" {
  type = string
  default = "${account_id}"
}

variable "hosted_zone_id" {
  type = string
  default = "test.com"
}
