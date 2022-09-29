output "oidc_provider_arn" {
  value = module.eks.oidc_provider_arn
}

output "cluster_name" {
  value = local.name
}

output "configure_kubectl" {
  description = "Configure kubectl: make sure you're logged in with the correct AWS profile and run the following command to update your kubeconfig"
  value       = module.eks_blueprints.configure_kubectl
}