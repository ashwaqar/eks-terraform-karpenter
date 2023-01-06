variable "vpc_name" {
  type = string
  default = "rnvp"
}

variable "environment" {
  type = string
  description = "Options: development, qa, staging, production"
  default = "production"
}

variable "env_abrv" {
  type = map(any)
  default = {
    development = "d"
    qa          = "q"
    int         = "i"
    staging     = "s"
    production  = "p"
  }
}
variable "region" {
  type    = string
  default = "us-east-1"
}


variable "cluster_name" {
  type = string
  default = "eks-ns"
}
