provider "aws" {
  region = local.region

}


data "aws_eks_cluster_auth" "default" {
  name = module.eks.cluster_name
}

data "terraform_remote_state" "aws_data" {
  backend = "s3"
  config = {
    bucket = "prod-rnd-terraform"
    key    = "awsdata/terraform.tfstate"
    region = "ap-northeast-2"
  }
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.default.token

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    # This requires the awscli to be installed locally where Terraform is executed
    args = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
  }
}


data "aws_availability_zones" "available" {}
data "aws_caller_identity" "current" {}

locals {
  name            = "prod-rnd-kr"
  cluster_version = "1.28"
  region          = "ap-northeast-2"

  vpc_id     = data.terraform_remote_state.aws_data.outputs.vpc_id
  subnet_ids = data.terraform_remote_state.aws_data.outputs.r_private_subnets_ids

  tags = {
    env  = "r"
    user = "gm"
  }
}

resource "aws_iam_policy" "additional" {
  name = "${local.name}-additional"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:Describe*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

module "kms" {
  source  = "terraform-aws-modules/kms/aws"
  version = "1.1.0"

  aliases               = ["eks/${local.name}"]
  description           = "${local.name} cluster encryption key"
  enable_default_policy = true
  key_owners            = [data.aws_caller_identity.current.arn]

  tags = local.tags
}
