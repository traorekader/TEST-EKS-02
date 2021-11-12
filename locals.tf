locals {
  cluster_name = "eks-${var.project_name}-${var.env}"
  namespace    = "zaka-app-${var.project_name}-${var.env}"
  project      = "Project-${var.project_name}-${var.env}"
  environment  = terraform.workspace

  # Define further aditional SSO Role

  default_tags = {
    Project     = local.project
    Environment = local.environment
    Owner       = "UD"
    ManagedBy   = "terraform"
  }
  tags = merge(local.default_tags, var.tags)

  // eks_oidc_provider_schemeless_url = replace(data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer, "/https?:///", "")

  base_eks_roles = [
    {
      rolearn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:${aws_iam_role.eks-assume-role.name}"
      username = "role1"
      groups   = ["system:masters"]
    }
  ]
  base_eks_users = []
  eks_roles      = local.base_eks_roles
  eks_users      = local.base_eks_users

  depends_on = [
    aws_iam_role.eks-assume-role
  ]

}