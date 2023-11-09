resource "aws_key_pair" "machine" {
  key_name   = var.keypair_name
  public_key = file(var.keypair_path)
}

resource "aws_instance" "bastion" {
  ami                    = var.instance_machine_ami
  instance_type          = var.instance_machine_type
  subnet_id              = aws_subnet.public[0].id
  key_name               = aws_key_pair.machine.key_name
  vpc_security_group_ids = [aws_security_group.sg_bastion_host.id]

  tags = {
    Name    = "${var.instance_name_prefix}-bastion"
    Network = "public"
  }
}
resource "aws_instance" "public" {
  ami                    = var.instance_machine_ami
  instance_type          = var.instance_machine_type
  subnet_id              = aws_subnet.public[0].id
  key_name               = aws_key_pair.machine.key_name
  vpc_security_group_ids = [aws_security_group.sg_bastion_client.id, aws_security_group.sg_instance.id]

  user_data = file("scripts/machine.sh")

  tags = {
    Name    = "${var.instance_name_prefix}-public"
    Network = "public"
  }
}

resource "aws_instance" "private" {
  ami                    = var.instance_machine_ami
  instance_type          = var.instance_machine_type
  subnet_id              = aws_subnet.private[0].id
  key_name               = aws_key_pair.machine.key_name
  vpc_security_group_ids = [aws_security_group.sg_bastion_client.id]

  tags = {
    Name    = "${var.instance_name_prefix}-private"
    Network = "private"
  }
}

resource "aws_instance" "private-no-bastion" {
  ami                    = var.instance_machine_ami
  instance_type          = var.instance_machine_type
  subnet_id              = aws_subnet.private[0].id
  key_name               = aws_key_pair.machine.key_name
  vpc_security_group_ids = [aws_security_group.sg_instance.id]

  tags = {
    Name    = "${var.instance_name_prefix}-private-no-bastion"
    Network = "private"
  }
}