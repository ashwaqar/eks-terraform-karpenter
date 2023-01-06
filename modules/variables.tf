variable "natgw_configuration" {
  type    = string
  default = "single_NATGW"
}

variable "cidr_ab" {
  type = map(any)
  default = {
    development = "172.22"
    qa          = "172.24"
    staging     = "172.26"
    production  = "172.28"
  }
}

variable "environment" {
  type        = string
  description = "Options: development, qa, staging, production"
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