output "vpc_id" {
  value = aws_vpc.webapp-vpc.id
}

output "subnet1_id" {
  value = aws_subnet.webapp-subnet_1.id
}

output "subnet2_id" {
  value = var.create_second_subnet ? aws_subnet.webapp-subnet_2[0].id : null
}
