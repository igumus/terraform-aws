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
  default     = "subnet-1"
  description = "VPC Primary subnet name"
}

variable "instance_machine_ami" {
  type = string
  default = "ami-01bc990364452ab3e"
  description = "EC2 instance ami"
}

variable "instance_machine_type" {
  type = string
  default = "t2.micro"
  description = "EC2 instance machine type"
}

variable "keypair_path" {
  type        = string
  description = "Keypair path"
  default     = "keys/tut002.pem.pub"
}

variable "keypair_name" {
  type = string
  description = "Keypair name"
  default = "kp-machine"
}