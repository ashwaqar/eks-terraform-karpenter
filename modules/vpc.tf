provider "aws" {
  region = local.region
}


################################################################################
# VPC Module
################################################################################

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = local.vpc_name
  cidr = "${lookup(var.cidr_ab, var.environment)}.0.0/16"

  # azs               = local.selected_azs[var.env] # https://stackoverflow.com/a/74038045
  azs = local.availability_zones

  private_subnets      = local.private_subnets
  private_subnet_names = local.private_subnet_names

  public_subnets      = local.public_subnets
  public_subnet_names = local.public_subnet_names

  database_subnets      = local.database_subnets
  database_subnet_names = local.database_subnet_names

  enable_ipv6 = true

  # https://stackoverflow.com/a/74036286  
  enable_nat_gateway     = local.natgw_states[var.natgw_configuration].enable_nat_gateway
  single_nat_gateway     = local.natgw_states[var.natgw_configuration].single_nat_gateway
  one_nat_gateway_per_az = local.natgw_states[var.natgw_configuration].one_nat_gateway_per_az

  # https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest#public-access-to-rds-instances
  create_database_subnet_group           = true
  create_database_subnet_route_table     = true
  create_database_internet_gateway_route = true

  enable_dns_hostnames = true
  enable_dns_support   = true


  # EKS addons for VPC
  manage_default_network_acl    = true
  default_network_acl_tags      = { Name = "${local.eks_name_ns}-default" }
  manage_default_route_table    = true
  default_route_table_tags      = { Name = "${local.eks_name_ns}-default" }
  manage_default_security_group = true
  default_security_group_tags   = { Name = "${local.eks_name_ns}-default" }

  public_subnet_tags = {
    environment                                  = var.environment
    "kubernetes.io/cluster/${local.eks_name_ns}" = "shared"
    "kubernetes.io/role/elb"                     = 1
  }

  private_subnet_tags = {
    environment                                  = var.environment
    "kubernetes.io/cluster/${local.eks_name_ns}" = "shared"
    "kubernetes.io/role/internal-elb"            = 1
    "karpenter.sh/discovery"                     = local.eks_name_ns
  }

  database_subnet_tags = {
    environment = var.environment
  }

  tags = local.tags

  vpc_tags = {
    Name = local.name_env
  }
}