# AWS Region
variable "region" {
  type = string
}

# VPC CIDR Block
variable "vpc_cidr" {
  type = string
}

# Subnet Definitions
variable "subnet1_cidr" {
  type = string
}
variable "subnet1_az" {
  type = string
}
variable "subnet2_cidr" {
  type = string
}
variable "subnet2_az" {
  type = string
}

# EC2 Instance Settings
variable "ami_id" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "user_data_file" {
  type = string
}

# Application Load Balancer (ALB)
variable "alb_name" {
  type = string
}

variable "target_group_name" {
  type = string
}

variable "alb_port" {
  type = number
}
