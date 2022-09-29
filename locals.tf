locals {
  common_tags = {
    terraform = "true"
    purpose   = ""
  }
  prefix = "pre-screening-eks-${var.environment}"
  partition = data.aws_partition.current.partition
}