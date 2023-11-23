provider "aws" {
  # AWS provider 설정
  region = "ap-northeast-2"
}

data "terraform_remote_state" "eks" {
  backend = "s3"
  config = {
    bucket = "r-rnd-terraform"
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

data "kubernetes_cluster_role" "aws_load_balancer_controller" {
  metadata {
    name = "aws-load-balancer-controller-role"
  }
}

resource "kubernetes_cluster_role_binding" "aws_load_balancer_controller_binding" {
  metadata {
    name = "aws-load-balancer-controller-binding"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.aws_load_balancer_controller.metadata[0].name
  }

  subject {
    kind      = "ServiceAccount"
    name      = "aws-load-balancer-controller" // Argo CD 설치 시 생성될 서비스 계정 이름
    namespace = "kube-system"                  // 서비스 계정이 생성될 네임스페이스
  }
}

resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  create_namespace = true
  values           = [file("argocd-values.yaml")]
}

# module "argocd" {
#   source  = "aigisuk/argocd/kubernetes//examples/default"
#   version = "0.2.7"
#   admin_password = "LineGames7!"
#     # insert the 1 required variable here
# }
