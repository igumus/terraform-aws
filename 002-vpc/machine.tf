resource "aws_key_pair" "machine" {
  key_name   = var.keypair_name
  public_key = file(var.keypair_path)
}

resource "aws_instance" "bastion" {
  ami                    = var.instance_machine_ami
  instance_type          = var.instance_machine_type
  subnet_id              = aws_subnet.public[var.vpc_primary_subnet_name].id
  key_name               = aws_key_pair.machine.key_name
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  tags = {
    Name    = "bastion"
    Network = "public"
  }
}
resource "aws_instance" "public" {
  ami                    = var.instance_machine_ami
  instance_type          = var.instance_machine_type
  subnet_id              = aws_subnet.public[var.vpc_primary_subnet_name].id
  key_name               = aws_key_pair.machine.key_name
  vpc_security_group_ids = [aws_security_group.allow_http.id, aws_security_group.allow_ssh_from_bastion.id]

  tags = {
    Name    = "machine-public"
    Network = "public"
  }
}

resource "aws_instance" "private" {
  ami                    = var.instance_machine_ami
  instance_type          = var.instance_machine_type
  subnet_id              = aws_subnet.private[var.vpc_primary_subnet_name].id
  key_name               = aws_key_pair.machine.key_name
  vpc_security_group_ids = [aws_security_group.allow_ssh_from_bastion.id]

  tags = {
    Name    = "machine-private"
    Network = "private"
  }
}

resource "aws_instance" "private-no-bastion" {
  ami                    = var.instance_machine_ami 
  instance_type          = var.instance_machine_type
  subnet_id              = aws_subnet.private[var.vpc_primary_subnet_name].id
  key_name               = aws_key_pair.machine.key_name
  vpc_security_group_ids = [aws_security_group.allow_http.id]

  tags = {
    Name    = "machine-private-no-bastion"
    Network = "private"
  }
}