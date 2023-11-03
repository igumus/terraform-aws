variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "us-east-1"
}

variable "keypair_path" {
  type        = string
  description = "Keypair path"
  default     = "keys/tut002.pem.pub"
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR block"
  default     = "10.0.0.0/16"
}

variable "vpc_name" {
  type        = string
  description = "VPC name"
  default     = "main"
}

variable "vpc_subnets" {
  description = "VPC subnets"
  default = {
    "subnet-1" = 1
    "subnet-2" = 2
    "subnet-3" = 3
  }
}

variable "vpc_primary_subnet_name" {
  type        = string
  description = "VPC Primary subnet name"
  default     = "subnet-1"
}