provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
    bucket = "terraform-state-alex8"
    region = "ap-south-1"
    key    = "terraform.tfstate"
  }
}
