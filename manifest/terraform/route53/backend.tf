terraform {
  backend "s3" {
    bucket         = "r-rnd-terraform"
    key            = "route53/terraform.tfstate"
    region         = "ap-northeast-2"
    dynamodb_table = "r-rnd-terraform-lock-route53"
    encrypt        = true
  }
}