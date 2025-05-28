resource "aws_lb_target_group" "webapp_tg" {
  name        = var.target_group_name
  port        = var.alb_port
  protocol    = "HTTP"
  vpc_id      = aws_vpc.webapp-vpc.id
  target_type = "instance"

  health_check {
    path                = "/"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_target_group_attachment" "attachments" {
  for_each = aws_instance.webapp

  target_group_arn = aws_lb_target_group.webapp_tg.arn
  target_id        = each.value.id
  port             = var.alb_port
}

resource "aws_lb" "webapp_alb" {
  name               = var.alb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.webapp_sg.id]
  subnets = [
    aws_subnet.webapp-subnet_1.id,
    aws_subnet.webapp-subnet_2.id
  ]

  tags = {
    Name = var.alb_name
  }
}

resource "aws_lb_listener" "webapp_listener" {
  load_balancer_arn = aws_lb.webapp_alb.arn
  port              = var.alb_port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.webapp_tg.arn
  }
}
