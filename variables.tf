variable "aws_region" {
  type    = string
  default = "ap-south-1"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  type    = string
  default = "10.0.0.0/24"
}

variable "cluster_name" {
  type    = string
  default = "example-eks-cluster"
}

variable "cluster_iam_role_name" {
  type    = string
  default = "eks-cluster-role"
}

variable "cluster_iam_role_arn" {
  type    = string
  default = "arn:aws:iam::875667920160:user/terraform"
}

variable "kubernetes_version" {
  type    = string
  default = "1.21"
}