variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "AWS region"
}


variable "vpc_cidr" {
  type        = string
  default     = "10.0.0.0/16"
  description = "VPC CIDR block"
}

variable "vpc_name" {
  type        = string
  default     = "main"
  description = "VPC name"
}

variable "vpc_public_subnet_count" {
  default = 1
}

variable "vpc_private_subnet_count" {
  default = 1
}

variable "instance_name_prefix" {
  type        = string
  default     = "machine"
  description = "EC2 instance name prefix"
}

variable "instance_machine_ami" {
  type        = string
  default     = "ami-01bc990364452ab3e"
  description = "EC2 instance ami"
}

variable "instance_machine_type" {
  type        = string
  default     = "t2.micro"
  description = "EC2 instance machine type"
}

variable "keypair_path" {
  type        = string
  description = "Keypair path"
  default     = "keys/tut002.pem.pub"
}

variable "keypair_name" {
  type        = string
  description = "Keypair name"
  default     = "kp-machine"
}