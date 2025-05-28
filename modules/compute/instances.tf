resource "aws_security_group" "webapp_sg" {
  name        = "Allow_port_22_and_80"
  description = "Allow SSH and web traffic"
  vpc_id      = aws_vpc.webapp-vpc.id

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

resource "aws_instance" "webapp" {
  for_each = {
    webapp-1 = aws_subnet.webapp-subnet_1.id
    webapp-2 = aws_subnet.webapp-subnet_2.id
  }

  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = each.value
  vpc_security_group_ids      = [aws_security_group.webapp_sg.id]
  associate_public_ip_address = true
  user_data                   = templatefile("${path.module}/${var.user_data_file}", {})

  tags = {
    Name = each.key
  }
}
