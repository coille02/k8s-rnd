resource "aws_eks_addon" "aws_ebs_csi_driver" {
  cluster_name             = module.eks.cluster_name
  addon_name               = "aws-ebs-csi-driver"
  service_account_role_arn = "arn:aws:iam::${var.aws_account_id}:role/AmazonEKS_EBS_CSI_DriverRole"
  addon_version            = "v1.25.0-eksbuild.1"
  # resolve_conflicts        = "OVERWRITE"
  resolve_conflicts_on_create = "OVERWRITE"
}
#${account_id} 