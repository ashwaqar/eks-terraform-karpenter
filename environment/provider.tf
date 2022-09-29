provider "aws" {
  region = var.region
}

data "aws_availability_zones" "available" {}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}