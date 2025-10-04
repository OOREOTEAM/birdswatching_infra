terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
}

module "Network" {
  source = "./modules/subnets_route_assoc"
  environment = var.environment
  vpc_id = var.vpc_id
  availability_zone = "eu-central-1c"
  public_subnet_cidr = var.public_subnet_cidr
  private_app_subnet_cidr = var.private_app_subnet_cidr
  private_db_subnet_cidr = var.private_db_subnet_cidr
  private_consul_subnet_cidr = var.private_consul_subnet_cidr
}