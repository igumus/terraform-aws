resource "aws_key_pair" "machine" {
  key_name   = var.keypair_name
  public_key = file(var.keypair_path)
}

resource "aws_instance" "public" {
  depends_on             = [aws_subnet.public]
  count                  = local.public_subnet_count
  ami                    = var.instance_ami
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public[count.index].id
  key_name               = aws_key_pair.machine.key_name
  vpc_security_group_ids = [aws_security_group.instance.id]

  user_data = file("scripts/public.sh")

  tags = {
    Name = "pub-${var.instance_name_prefix}-${count.index}"
    Tier = "public"
    Vpc  = var.vpc_name
  }
}

resource "aws_instance" "private" {
  depends_on             = [aws_subnet.private]
  count                  = local.private_subnet_count
  ami                    = var.instance_ami
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.private[count.index].id
  key_name               = aws_key_pair.machine.key_name
  vpc_security_group_ids = [aws_security_group.instance.id]

  user_data = file("scripts/private.sh")

  tags = {
    Name = "priv-${var.instance_name_prefix}-${count.index}"
    Tier = "private"
    Vpc  = var.vpc_name
  }
}

