resource "aws_key_pair" "machine" {
  key_name   = "kp-machine"
  public_key = file(var.keypair_path)
}

resource "aws_instance" "bastion" {
  ami                    = "ami-01bc990364452ab3e"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public[var.vpc_primary_subnet_name].id
  key_name               = aws_key_pair.machine.key_name
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  tags = {
    Name    = "bastion"
    Network = "public"
  }
}
resource "aws_instance" "public" {
  ami                    = "ami-01bc990364452ab3e"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public[var.vpc_primary_subnet_name].id
  key_name               = aws_key_pair.machine.key_name
  vpc_security_group_ids = [aws_security_group.allow_http.id, aws_security_group.allow_ssh_from_bastion.id]

  tags = {
    Name    = "machine-public"
    Network = "public"
  }
}

resource "aws_instance" "private" {
  ami                    = "ami-01bc990364452ab3e"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.private[var.vpc_primary_subnet_name].id
  key_name               = aws_key_pair.machine.key_name
  vpc_security_group_ids = [aws_security_group.allow_ssh_from_bastion.id]

  tags = {
    Name    = "machine-private"
    Network = "private"
  }
}

resource "aws_instance" "private-no-bastion" {
  ami                    = "ami-01bc990364452ab3e"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.private[var.vpc_primary_subnet_name].id
  key_name               = aws_key_pair.machine.key_name
  vpc_security_group_ids = [aws_security_group.allow_http.id]

  tags = {
    Name    = "machine-private-no-bastion"
    Network = "private"
  }
}