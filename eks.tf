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
  enable_irsa = true


  # additional requirments
  workers_role_name         = "iam-eks-workers-role"
  create_eks                = true
  manage_aws_auth           = true
  write_kubeconfig          = true
  kubeconfig_output_path    = "/root/.kube/config" # touch /root/.kube/config   # for terraform HELM provider, we neeed this + #  Error: configmaps "aws-auth" already exists 
  kubeconfig_name           = "config"                                                                                         #  Solution: kubectl delete configmap aws-auth -n kube-system

  # Node groups
  node_groups = {
    eks-workers = {
      create_launch_template = true
      name                   = "worker"  # Eks Workers Node Groups Name
      instance_types         = ["t3a.medium"]
      capacity_type          = "ON_DEMAND"
      desired_capacity       = 1
      max_capacity           = 2
      min_capacity           = 1
      disk_type              = "gp3"
      disk_size              = 30
      ebs_optimized          = true
      disk_encrypted         = true
      key_name               = "terraform-worker-node"
      enable_monitoring      = true

      additional_tags = {
        "Name"                     = "eks-worker"                            # Tags for Cluster Worker Nodes
        "karpenter.sh/discovery"   = var.cluster_name
      }

    }
  }

  tags = {
    environment = var.environment
    name = "${local.prefix}-node-group"
    "karpenter.sh/discovery" = var.cluster_name
  }
}


data "aws_eks_cluster_auth" "eks" {
  name = module.eks.cluster_id
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.eks.token
}