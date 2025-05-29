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

variable "create_second_subnet" {
  type    = bool
  default = true
}
