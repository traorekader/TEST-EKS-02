locals {
  cluster_name = "${var.project_name}-${var.env}"
  namespace    = "${var.project_name}_${var.env}"
}