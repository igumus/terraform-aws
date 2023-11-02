variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "aws_zone" {
  description = "AWS availability zone"
  default     = "us-east-1a"
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t2.micro"
}

variable "ami_id" {
  description = "ID of the AMI. Default is Amazon Linux 2023 AMI"
  default     = "ami-01bc990364452ab3e"
}

variable "name" {
  description = "EC2 instance name"
  default     = "machine"
}
