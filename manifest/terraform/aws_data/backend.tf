# Backend for tfstate in S3
terraform {
  backend "s3" {
    bucket         = "r-rnd-terraform"
    key            = "awsdata/terraform.tfstate"
    region         = "ap-northeast-2"
    dynamodb_table = "r-rnd-terraform-lock-awsdata"
    profile        = "rnd-prod"
    encrypt        = true
  }
}
