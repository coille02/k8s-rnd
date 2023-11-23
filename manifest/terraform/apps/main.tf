provider "aws" {
  # AWS provider 설정
  region = "ap-northeast-2"
}

data "terraform_remote_state" "eks" {
  backend = "s3"
  config = {
    bucket = "r-rnd-terraform"
    key    = "eks/terraform.tfstate"
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

resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  namespace  = "argocd"
  create_namespace = true

  set {
    name  = "server.service.type"
    value = "LoadBalancer"
  }

  timeout = 1800
}

# resource "kubernetes_namespace" "argocd_namespace" {
#   metadata {
#     annotations = {
#       name = "argocd"
#     }

#     labels = {
#       mylabel = "label-value"
#     }

#     name = "argocd"
#   }
# }


# resource "helm_release" "argocd" {
#     name       = "argocd"
#     repository = "https://argoproj.github.io/argo-helm"
#     chart      = "argo-cd"
#     version    = "3.19.0"

#     # namespace  = kubernetes_namespace.argocd_namespace.metadata[0].name

#     set {
#         name  = "server.service.type"
#         value = "LoadBalancer"
#     }

#     set {
#         name  = "server.extraArgs={--insecure}"
#         value = "true"
#     }
# }


# resource "helm_release" "prometheus" {
#     name       = "prometheus"
#     repository = "https://prometheus-community.github.io/helm-charts"
#     chart      = "prometheus"
#     version    = "25.6.0"  # 원하는 Prometheus 버전으로 수정

#     namespace  = "monitoring"

#     set {
#         name  = "server.persistentVolume.enabled"
#         value = "false"
#     }

#     set {
#         name  = "server.service.type"
#         value = "LoadBalancer"
#     }
# }