resource "aws_security_group" "sg_instance" {
  name        = "sg_instance"
  description = "Security Group for EC2 Web Servers"
  vpc_id      = aws_vpc.main.id
  tags = {
    Name = "sg_instance"
    Tier = "web-server"
  }
}

resource "aws_security_group" "sg_bastion_host" {
  name        = "sg_bastion_host"
  description = "Security Group for Bastion Host"
  vpc_id      = aws_vpc.main.id
  tags = {
    Name = "sg_bastion_host"
    Tier = "bastion"
    Kind = "host"
  }
}

resource "aws_security_group" "sg_bastion_client" {
  name        = "sg_bastion_client"
  description = "Security Group for Bastion Client"
  vpc_id      = aws_vpc.main.id
  tags = {
    Name = "sg_bastion_client"
    Tier = "bastion"
    Kind = "client"
  }
}

resource "aws_security_group_rule" "instance_http_ingress" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sg_instance.id
}

resource "aws_security_group_rule" "instance_all_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sg_instance.id
}

resource "aws_security_group_rule" "bastion_client_ssh_ingress" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.sg_bastion_host.id
  security_group_id        = aws_security_group.sg_bastion_client.id
}

resource "aws_security_group_rule" "bastion_client_all_egress" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.sg_bastion_client.id
}

resource "aws_security_group_rule" "bastion_host_ssh_ingress" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sg_bastion_host.id
}

resource "aws_security_group_rule" "bastion_host_ssh_egress" {
  type                     = "egress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.sg_bastion_client.id
  security_group_id        = aws_security_group.sg_bastion_host.id
}

resource "aws_security_group_rule" "bastion_host_all_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sg_bastion_host.id
}

