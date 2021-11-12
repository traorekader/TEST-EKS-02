resource "random_pet" "this" {
  length = 2
}

module "eks_cluster" {
  source  = "terraform-aws-modules/eks/aws"
  version = ">= 17.0.0"

  cluster_name                          = local.cluster_name
  cluster_version                       = var.kubernetes_version
  subnets                               = module.vpc.public_subnets
  vpc_id                                = module.vpc.vpc_id
  cluster_endpoint_private_access_cidrs = ["0.0.0.0/0"]

  // enable_irsa = true

  #   write_kubeconfig = true

  # ERROR Creating EKS Node Group: InvalidRequestException: Cannot specify instance types in launch template and API Request
  # resolved it by adding instance_types=[] to node_groups_defaults
  # https://github.com/terraform-aws-modules/terraform-aws-eks/issues/1386
  node_groups_defaults = {
    instance_types = []
  }

  // TODO leverage spot instances ?
  node_groups = {
    workers-1 = {
      name             = "${local.cluster_name}-workers-${random_pet.this.id}-group"
      desired_capacity = var.workers_desired
      max_capacity     = var.workers_max
      min_capacity     = var.workers_min

      launch_template_id      = aws_launch_template.worker.id
      launch_template_version = aws_launch_template.worker.default_version

      subnets = module.vpc.public_subnets
    }
  }

  map_roles = local.eks_roles
  map_users = local.eks_users
  tags      = local.default_tags

}

