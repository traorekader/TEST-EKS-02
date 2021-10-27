resource "random_pet" "this" {
  length = 2
}

module "eks_cluster" {
  source  = "terraform-aws-modules/eks/aws"
  version = "13.2.1"

  cluster_name                          = local.cluster_name
  cluster_version                       = var.kubernetes_version
  subnets                               = module.vpc.private_subnets
  vpc_id                                = module.vpc.vpc_id
  cluster_endpoint_private_access_cidrs = ["0.0.0.0/0"]

  #   write_kubeconfig = true

  // TODO leverage spot instances ?
  node_groups = {
    workers = {
      name             = "${local.cluster_name}-workers-${random_pet.this.id}-group"
      desired_capacity = var.workers_desired
      max_capacity     = var.workers_max
      min_capacity     = var.workers_min

      launch_template_id      = aws_launch_template.worker.id
      launch_template_version = aws_launch_template.worker.default_version

      subnets = module.vpc.private_subnets
    }
  }


  # TODO: multiple workers by environments

  # does not work when specifying public and private subnets on the cluster module
  # fargate_profiles = {
  #   sls_worker = {
  #     namespace = "default"
  #     # Kubernetes labels for selection
  #     labels = {
  #       Type        = "serverless"
  #     }
  #     tags = local.default_tags
  #   }
  # }

}

