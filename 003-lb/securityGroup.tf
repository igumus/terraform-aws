resource "aws_security_group" "instance" {
  name        = "sg_instance"
  description = "Security Group for EC2"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "sg_instance"
    Type = "ec2"
  }
}

resource "aws_security_group_rule" "allow_to_internet" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.instance.id
}

resource "aws_security_group_rule" "allow_http_from_lb" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.instance.id
  source_security_group_id = aws_security_group.lb.id
}

resource "aws_security_group" "lb" {
  name        = "sg_lb"
  description = "Security Group for ELB"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "sg_lb"
    Type = "elb"
  }
}

resource "aws_security_group_rule" "allow_http_from_internet" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.lb.id
}

resource "aws_security_group_rule" "allow_http_to_instance" {
  type                     = "egress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.lb.id
  source_security_group_id = aws_security_group.instance.id
}