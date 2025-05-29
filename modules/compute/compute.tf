## EC2 Instances for Web Application
resource "aws_security_group" "webapp_sg" {
  name        = "Allow_port_22_and_80"
  description = "Allow SSH and web traffic"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
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
}

# resource "aws_instance" "webapp" {
#   for_each = {
#     webapp-1 = var.subnet1_id,
#     webapp-2 = var.subnet2_id
#   }
#   ami                         = var.ami_id
#   instance_type               = var.instance_type
#   subnet_id                   = each.value
#   vpc_security_group_ids      = [aws_security_group.webapp_sg.id]
#   associate_public_ip_address = true
#   user_data                   = templatefile("${path.root}/${var.user_data_file}", {})

#   tags = {
#     Name = each.key
#   }
# }

resource "aws_instance" "webapp_1" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet1_id
  vpc_security_group_ids      = [aws_security_group.webapp_sg.id]
  associate_public_ip_address = true
  user_data                   = templatefile("${path.root}/${var.user_data_file}", {})

  tags = {
    Name = "${terraform.workspace}-webapp-1"
  }
}
resource "aws_instance" "webapp_2" {
  count                       = var.create_second_instance ? 1 : 0
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet2_id
  vpc_security_group_ids      = [aws_security_group.webapp_sg.id]
  associate_public_ip_address = true
  user_data                   = templatefile("${path.root}/${var.user_data_file}", {})

  tags = {
    Name = "${terraform.workspace}-webapp-2"
  }

}

## ALB Target Group Attachment
resource "aws_lb_target_group" "webapp_tg" {
  name        = var.target_group_name
  port        = var.alb_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
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

# resource "aws_lb_target_group_attachment" "attachments" {
#   for_each = aws_instance.webapp

#   target_group_arn = aws_lb_target_group.webapp_tg.arn
#   target_id        = each.value.id
#   port             = var.alb_port
# }

resource "aws_lb_target_group_attachment" "webapp_1" {
  target_group_arn = aws_lb_target_group.webapp_tg.arn
  target_id        = aws_instance.webapp_1.id
  port             = var.alb_port
}

resource "aws_lb_target_group_attachment" "webapp_2" {
  count            = var.create_second_instance ? 1 : 0
  target_group_arn = aws_lb_target_group.webapp_tg.arn
  target_id        = aws_instance.webapp_2[0].id
  port             = var.alb_port
}

resource "aws_lb" "webapp_alb" {
  name               = var.alb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.webapp_sg.id]
  subnets = var.create_second_instance && var.subnet2_id != null ? [
    var.subnet1_id,
    var.subnet2_id
    ] : [
    var.subnet1_id
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
