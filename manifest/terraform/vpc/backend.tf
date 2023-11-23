terraform {
  backend "s3" {
    bucket         = "r-rnd-terraform"
    key            = "vpc/terraform.tfstate"
    region         = "ap-northeast-2"
    dynamodb_table = "r-rnd-terraform-lock-vpc"
    encrypt        = true
  }
}