variable "region" {
  description = "The AWS region to deploy resources"
  default     = "us-east-2"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "num_public_subnets" {
  description = "The number of public subnets"
  default     = 1
}

variable "num_private_subnets" {
  description = "The number of private subnets"
  default     = 1
}

variable "num_nat_gateways" {
  description = "The number of NAT gateways"
  default     = 1
}

variable "public_subnet_cidrs" {
  description = "The CIDR blocks for the public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "private_subnet_cidrs" {
  description = "The CIDR blocks for the private subnets"
  type        = list(string)
  default     = ["10.0.2.0/24"]
}

variable "desired_capacity" {
  description = "Desired capacity of the EKS node group"
  type        = number
  default     = 1
}

variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
  default     = "team2-cluster"
}
