output "alb_dns_name" {
  value = aws_lb.webapp_alb.dns_name
}
output "webapp_1_ip" {
  value = aws_instance.webapp_1.public_ip
}
output "webapp_2_ip" {
  value = try(aws_instance.webapp_2[0].public_ip, null)
}
# output "public_ips" {
#   value = [for instance in aws_instance.webapp : instance.public_ip]
# }
# output "instance_ids" {
#   value = [for instance in aws_instance.webapp : instance.id]
# }
