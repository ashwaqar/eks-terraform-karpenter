locals {
  common_tags = {
    terraform = "true"
    purpose   = ""
  }
  prefix = "pre-screening-eks-${var.environment}"
}