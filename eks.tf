module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "18.29.0"

  cluster_version = var.kubernetes_version

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  cluster_name  = var.cluster_name  
  vpc_id        = module.vpc.vpc_id
  subnet_ids    = module.vpc.private_subnets

  cluster_enabled_log_types = var.cluster_enabled_log_types

  # Required for Karpenter role below
  enable_irsa = true

  # We will rely only on the cluster security group created by the EKS service
  # See note below for `tags`
  create_cluster_security_group = false
  create_node_security_group    = false

  # Node groups
  eks_managed_node_groups = {
    initial = {
      instance_types = ["t3.medium"]
      # We don't need the node security group since we are using the
      # cluster-created security group, which Karpenter will also use
      create_security_group                 = false
      attach_cluster_primary_security_group = true

      min_size     = 1
      max_size     = 1
      desired_size = 1

      iam_role_additional_policies = [
        # Required by Karpenter
        "arn:${local.partition}:iam::aws:policy/AmazonSSMManagedInstanceCore"
      ]
    }
  }

  tags = {
    environment = var.environment
    name = "${local.prefix}-node-group"
    "karpenter.sh/discovery" = var.cluster_name
  }
}
