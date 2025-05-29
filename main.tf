module "network" {
  source       = "./modules/network"
  region       = var.region
  vpc_cidr     = var.vpc_cidr
  subnet1_cidr = var.subnet1_cidr
  subnet2_cidr = var.subnet2_cidr
  subnet1_az   = var.subnet1_az
  subnet2_az   = var.subnet2_az
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
}
