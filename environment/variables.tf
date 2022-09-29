variable "environment" {
  type = string
}

variable "region" {
  type    = string
  default = "eu-central-1"
}

variable "kubernetes_version" {
  type    = string
  default = "1.23"
}

variable "cluster_name" {
  type = string
}

variable "cluster_enabled_log_types" {
  type    = list(string)
  default = ["audit", "api", "authenticator", "controllerManager", "scheduler"]
}

variable "cluster_endpoint_private_access_cidrs" {
  type    = list(string)
  default = []
}

variable "desired_size" {
  type = number
}

variable "min_size" {
  type = number
}

variable "max_size" {
  type = number
}
