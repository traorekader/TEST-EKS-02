resource "aws_launch_template" "worker" {
  #checkov:skip=CKV_AWS_79 : issue in k8s when using metadata v2 tokens (see comments below)
  name_prefix            = "${local.namespace}-eks-worker-"
  description            = "EKS Worker Launch Template"
  update_default_version = true

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size           = 100
      volume_type           = "gp2"
      delete_on_termination = true
      encrypted             = true

      # Enable this if you want to encrypt your node root volumes with a KMS/CMK.
      # Encryption of PVCs is handled via k8s StorageClass though
    }
  }

  instance_type = var.workers_instance_type
  image_id      = data.aws_ami.eks_ami.id

  network_interfaces {
    associate_public_ip_address = false
    delete_on_termination       = true
    security_groups             = [module.eks_cluster.worker_security_group_id]
  }

  # issues when activated so disabled it :(
  # AWS LB Controller does not succeed to access metadata
  # Internally when trying a curl response is a 401 (tokens need to be used)
  # tokens could be used but the AWS LB Controller use case makes these options unuseful
  # metadata_options {
  #   http_endpoint               = "enabled"
  #   http_tokens                 = "required"
  #   http_put_response_hop_limit = 1
  # }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${local.cluster_name}-ec2"
    }
  }
  tag_specifications {
    resource_type = "volume"
    tags = {
      Name = "${local.cluster_name}-vol"
    }
  }


  lifecycle {
    create_before_destroy = true
  }
}