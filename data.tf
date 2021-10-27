data "aws_ami" "eks_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amazon-eks-node-${var.kubernetes_version}-v*"]
  }
}

data "http" "workstation-external-ip" {
  url = "http://ipv4.icanhazip.com"
}

