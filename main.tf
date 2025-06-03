module "network" {
  source       = "./modules/network"
  region       = var.region
  vpc_cidr     = var.vpc_cidr
  subnet1_cidr = var.subnet1_cidr
  subnet2_cidr = var.subnet2_cidr
  subnet1_az   = var.subnet1_az
  subnet2_az   = var.subnet2_az

  create_second_subnet = var.create_second_subnet
}

module "compute" {
  source            = "./modules/compute"
  ami_id            = var.ami_id
  instance_type     = var.instance_type
  user_data_file    = var.user_data_file
  alb_name          = var.alb_name
  alb_port          = var.alb_port
  target_group_name = var.target_group_name

  vpc_id     = module.network.vpc_id
  subnet1_id = module.network.subnet1_id
  subnet2_id = module.network.subnet2_id

  create_second_instance = var.create_second_instance
}

# output "public_ips" {
#   description = "Public IPs of the web application instances"
#   value       = module.compute.public_ips
# }
output "webapp_1_ip" {
  description = "Public IP of the first web application instance"
  value       = module.compute.webapp_1_ip
}
output "webapp_2_ip" {
  description = "Public IP of the second web application instance"
  value       = module.compute.webapp_2_ip
}

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = module.compute.alb_dns_name
}

output "vpc_id" {
  description = "ID of the VPC"
  value       = module.network.vpc_id
}

output "subnet1_id" {
  description = "ID of the first subnet"
  value       = module.network.subnet1_id

}
output "subnet2_id" {
  description = "ID of the second subnet"
  value       = module.network.subnet2_id
}
