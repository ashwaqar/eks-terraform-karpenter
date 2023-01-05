locals {
  name        = "rnv"
  name_env    = "${local.name}${lookup(var.env_abrv, var.environment)}"
  vpc_name    = "${local.name_env}-vpc"
  eks_name_ns = "${local.name_env}-eks-ns"

  env = var.environment

  region = "us-east-1"

  # example values of the paramters. You have to setup
  # correct values of each state you want
  natgw_states = {
    "NATGW_disabled" = {
      enable_nat_gateway     = false
      single_nat_gateway     = false
      one_nat_gateway_per_az = false
    }
    "single_NATGW" = {
      enable_nat_gateway     = true
      single_nat_gateway     = true
      one_nat_gateway_per_az = false
    }
    "1_NATGW_per_subnet" = {
      enable_nat_gateway     = true
      single_nat_gateway     = false
      one_nat_gateway_per_az = false
    }
    "1_NATGW_per_AZ" = {
      enable_nat_gateway     = true
      single_nat_gateway     = false
      one_nat_gateway_per_az = true
    }
  }

  # selected_azs = {
  #   "dev"       = [for i in range(3): data.aws_availability_zones.available.names[i]]
  #   "stage"     = [for i in range(4): data.aws_availability_zones.available.names[i]]
  #   "prod"      = data.aws_availability_zones.available.names
  # } # https://stackoverflow.com/a/74038045


  tags = {
    resource    = local.vpc_name
    environment = var.environment
  }
}

##########################
# availability_zones
############################
data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  availability_zones = data.aws_availability_zones.available.names
}

##########################
# subnets  # https://medium.com/prodopsio/terraform-aws-dynamic-subnets-455619dd1977
############################

locals {
  cidr_c_private_subnets  = 1
  cidr_c_database_subnets = 11
  cidr_c_public_subnets   = 64

  max_private_subnets  = 3
  max_database_subnets = 3
  max_public_subnets   = 3
}

locals {
  private_subnets = [
    for az in local.availability_zones :
    "${lookup(var.cidr_ab, var.environment)}.${local.cidr_c_private_subnets + index(local.availability_zones, az)}.0/24"
    if index(local.availability_zones, az) < local.max_private_subnets
  ]
  database_subnets = [
    for az in local.availability_zones :
    "${lookup(var.cidr_ab, var.environment)}.${local.cidr_c_database_subnets + index(local.availability_zones, az)}.0/24"
    if index(local.availability_zones, az) < local.max_database_subnets
  ]
  public_subnets = [
    for az in local.availability_zones :
    "${lookup(var.cidr_ab, var.environment)}.${local.cidr_c_public_subnets + index(local.availability_zones, az)}.0/24"
    if index(local.availability_zones, az) < local.max_public_subnets
  ]
}

locals {
  private_subnet_names = [
    for az in local.availability_zones :
    "${local.name_env}-prsubnt-${local.cidr_c_private_subnets + index(local.availability_zones, az)}"
    if index(local.availability_zones, az) < local.max_private_subnets
  ]
  database_subnet_names = [
    for az in local.availability_zones :
    "${local.name_env}-dbsubnt-${local.cidr_c_database_subnets + index(local.availability_zones, az)}"
    if index(local.availability_zones, az) < local.max_database_subnets
  ]
  public_subnet_names = [
    for az in local.availability_zones :
    "${local.name_env}-psubnt-${local.cidr_c_public_subnets + index(local.availability_zones, az)}"
    if index(local.availability_zones, az) < local.max_public_subnets
  ]
}