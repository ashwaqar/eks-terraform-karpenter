###################################################
# EKS Cluster Auto-Scaling Karpenter Node IAM Role
###################################################
module "karpenter_node_iam_role" {
  source = "../modules/eks-karpenter-node-iam-role"
  cluster_name                =  var.cluster_name
  ssm_managed_instance_policy =  "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  worker_iam_role_name        =  module.eks.worker_iam_role_name
}

##############################
# KarpenterController IAM Role
##############################
module "karpenter_controller_iam_role" {
  source = "../modules/eks-karpenter-controller-iam-role"
  cluster_name            = var.cluster_name
  cluster_oidc_issuer_url = module.eks.cluster_oidc_issuer_url
}

########################################################
# Must Install the latest version of aws cli & terraform
########################################################
# aws eks get-token --cluster-name xxxxx | jq '.apiVersion'    # Note: Install the lastest version of terraform & awscli is must  
########################
# Karpenter installation
########################
module "karpernter_installation" {
  source = "../modules/eks-karpenter-installation"
  cluster_endpoint                          = module.eks.cluster_endpoint
  cluster_name                              = var.cluster_name
  instance_profile                          = module.eks.worker_iam_role_name
  iam_assumable_role_karpenter_iam_role_arn = module.karpenter_controller_iam_role.iam_assumable_role_karpenter_iam_role_arn
  kubeconfig                                = module.eks.kubeconfig
  cluster_ca_certificate                    = base64decode(module.eks.cluster_certificate_authority_data) 
  karpenter_version                         = "v0.5.3"
}
