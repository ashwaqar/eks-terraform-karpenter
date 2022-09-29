locals {
  prefix = "pre-screening-eks-${var.environment}"
  name   = "${var.cluster_name}"
  region = "${var.region}"

  node_group_name = "managed-ondemand"

  vpc_cidr = "10.0.0.0/16"
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)

  tags = {
    environment = var.environment
    Blueprint   = local.name
    GithubRepo  = "github.com/aws-ia/terraform-aws-eks-blueprints"
  }

}