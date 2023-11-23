provider "aws" {
  # AWS provider 설정
  region = "ap-northeast-2"
}

data "terraform_remote_state" "eks" {
  backend = "s3"
  config = {
    bucket = "prod-rnd-terraform"
    key    = "stage-eks/terraform.tfstate"
    region = "ap-northeast-2"
  }
}

data "aws_eks_cluster_auth" "cluster_auth" {
  name = data.terraform_remote_state.eks.outputs.cluster_name
}


provider "kubernetes" {
  config_path = "~/.kube/config"
  #   host                   = data.terraform_remote_state.eks.outputs.cluster_endpoint
  #   cluster_ca_certificate = base64decode(data.terraform_remote_state.eks.outputs.cluster_certificate_authority_data)
  #   token                  = data.aws_eks_cluster_auth.cluster_auth.token
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
    # host                   = data.terraform_remote_state.eks.outputs.cluster_endpoint
    # cluster_ca_certificate = base64decode(data.terraform_remote_state.eks.outputs.cluster_certificate_authority_data)
    # token                  = data.aws_eks_cluster_auth.cluster_auth.token
  }
}

# resource "kubernetes_namespace" "argocd" {
#   metadata {
#     name = "argocd"
#   }
# }


resource "helm_release" "datadog_agent" {
  name             = "datadog"
  repository       = "https://helm.datadoghq.com"
  chart            = "datadog"
  namespace        = "datadog"
  create_namespace = true
  values           = [file("datadog-values.yaml")]
}

# module "argocd" {
#   source  = "aigisuk/argocd/kubernetes//examples/default"
#   version = "0.2.7"
#   admin_password = "LineGames7!"
#     # insert the 1 required variable here
# }
