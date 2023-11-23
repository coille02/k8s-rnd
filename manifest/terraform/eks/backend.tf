# Backend for tfstate in S3
terraform {
  backend "s3" {
    bucket         = "r-rnd-terraform"
    key            = "eks/terraform.tfstate"
    region         = "ap-northeast-2"
    dynamodb_table = "r-rnd-terraform-lock-eks"
    profile        = "rnd-prod"
    encrypt        = true
  }
}
