variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "us-east-1"
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

variable "vpc_public_subnet_count" {
  default     = 2
  description = "VPC public subnets"
}

variable "vpc_private_subnet_count" {
  default     = 2
  description = "VPC private subnets"
}

variable "keypair_name" {
  type        = string
  description = "Keypair name"
  default     = "kp-machine"
}

variable "keypair_path" {
  type        = string
  description = "Keypair path"
  default     = "keys/tut003.pem.pub"
}

variable "instance_name_prefix" {
  type        = string
  default     = "machine"
  description = "EC2 instance name prefix"
}

variable "instance_type" {
  type        = string
  default     = "t2.micro"
  description = "EC2 instance type"
}

variable "instance_ami" {
  type        = string
  default     = "ami-01bc990364452ab3e"
  description = "EC2 instance ami"
}
