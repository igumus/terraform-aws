data "aws_vpc" "main" {
  default = true
  state   = "available"
}

resource "aws_key_pair" "machine" {
  key_name   = "kp-machine"
  public_key = file("keys/tut001.pem.pub")
}

resource "aws_security_group" "allow_http_ssh" {
  name        = "allow_http_ssh"
  description = "Allow HTTP and SSH inbound traffic"
  vpc_id      = data.aws_vpc.main.id

  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_http_ssh"
  }
}

resource "aws_instance" "machine" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  availability_zone      = var.aws_zone
  key_name               = aws_key_pair.machine.key_name
  vpc_security_group_ids = [aws_security_group.allow_http_ssh.id]

  tags = {
    Name = "${var.name}"
  }
}
