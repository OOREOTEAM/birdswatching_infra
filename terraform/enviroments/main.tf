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

module "security_groups" {
  source = "./modules/security_groups"
  vpc_id = var.vpc_id
  environment = var.environment
}

module "EC2_instances" {
  source = "./modules/ec2"
  environment = var.environment
  ami_id = var.ami_id
  instance_type = var.instance_type
  vpc_id = var.vpc_id
  webapp_sg_id = module.security_groups.webapp_sg_id
  nginx_lb_sg_id = module.security_groups.nginx_lb_sg_id
  consul_sg_id = module.security_groups.consul_sg_id
  database_sg_id = module.security_groups.database_sg_id
  private_webapp_subnet_id = module.Network.private_webapp_subnet_id
  public_lb_subnet_id = module.Network.public_lb_subnet_id
  private_db_subnet_id = module.Network.private_db_subnet_id
  private_consul_subnet_id = module.Network.private_db_subnet_id
}