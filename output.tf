output "oidc_provider_arn" {
  value = module.eks.oidc_provider_arn
}

output "cluster_name" {
  value = var.cluster_name
}

output "cluster_platform_version" {
  value = module.eks.cluster_platform_version
}

# output "eks_cluster_autoscaler_arn" {
#   value = aws_iam_role.eks_cluster_autoscaler.arn
# }