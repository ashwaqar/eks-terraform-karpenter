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

  #The enable_irsa flag will lead to the OIDC (OpenID Connect) provider being created.
  # enable_irsa = true

  tags = {
    environment = var.environment
    name = "${local.prefix}-node-group"
  }
}
