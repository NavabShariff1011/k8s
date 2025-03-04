variable "region" {
    default = "eu-central-1"
}

variable "profile" {
    default = "mainnet"
}


variable "vpc_name" {
    default = "mainnet"
}


variable "vpc_cidr" {
    default = "192.168.0.0/16"
}

variable "azs" {
    type = list
    default = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
}

variable "public_subnet_cidr" {
    type = list
    default = ["192.168.0.0/20", "192.168.16.0/20", "192.168.32.0/20"]
}

variable "public_subnet_names" {
    type = list
    default = ["mainnet-public-subnet-1", "mainnet-public-subnet-2", "mainnet-public-subnet-3"]
}


variable "private_subnet_cidr" {
    type = list
    default = ["192.168.48.0/20", "192.168.64.0/20", "192.168.80.0/20"]
}


variable "private_subnet_names" {
    type = list
    default = ["mainnet-private-subnet-1", "mainnet-private-subnet-2", "mainnet-private-subnet-3"]
}

variable "public_subnet_tags" {
  type = map(any)
  default = {
    "kubernetes.io/cluster/eks" = "owned"
    "kubernetes.io/role/elb"    = 1
  }
}


variable "private_subnet_tags" {
    type = map(any)
    default = {
      "kubernetes.io/cluster/eks" = "owned"
      "kubernetes.io/role/internal-elb"    = 1
  }
}

# nat

variable "enable_nat_gateway" {
  type    = bool
  default = true
}
