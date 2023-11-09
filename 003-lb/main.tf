resource "aws_lb_target_group" "public_tg" {
  name     = "lb-tg-public"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
  tags = {
    Name = "lb-tg-public"
    Vpc  = var.vpc_name
    Tier = "public"
  }
}

resource "aws_lb_target_group_attachment" "public_tg_attachment" {
  target_group_arn = aws_lb_target_group.public_tg.arn
  port             = 80
  count            = length(aws_instance.public)
  target_id        = aws_instance.public[count.index].id
}

resource "aws_lb_target_group" "private_tg" {
  name     = "lb-tg-private"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
  tags = {
    Name = "lb-tg-private"
    Vpc  = var.vpc_name
    Tier = "private"
  }
}

resource "aws_lb_target_group_attachment" "private_tg_attachment" {
  target_group_arn = aws_lb_target_group.private_tg.arn
  port             = 80
  count            = length(aws_instance.private)
  target_id        = aws_instance.private[count.index].id
}

resource "aws_lb" "lb" {
  name               = "lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb.id]
  subnets            = [for subnet in aws_subnet.public : subnet.id]

  enable_deletion_protection = false

  tags = {
    Name        = "lb"
    Environment = "testing"
  }
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.public_tg.arn
  }
}

resource "aws_lb_listener_rule" "listener_rule" {
  listener_arn = aws_lb_listener.listener.arn
  action {
    type = "forward"
    forward {
      target_group {
        arn    = aws_lb_target_group.public_tg.arn
        weight = 80
      }

      target_group {
        arn    = aws_lb_target_group.private_tg.arn
        weight = 20
      }
    }
  }
  condition {
    path_pattern {
      values = ["/"]
    }
  }
}