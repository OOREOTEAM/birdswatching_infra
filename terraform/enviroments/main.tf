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

#The s3_bucket_pictures includes creation of S3 bucket for webapp
module "s3_bucket_pictures" {
  source = "./modules/s3_bucket_pictures"
  environment                = var.environment
}

#The IAM module creates rule for webapp to access S3 bucket and SSM manager for all instances 
module "iam" {
  source = "./modules/iam"
  environment            = var.environment
  s3_bucket_pictures_arn = module.s3_bucket_pictures.s3_bucket_pictures_arn
}

#Network module includes creation of subnets and route table assosiation
module "Network" {
  source                     = "./modules/subnets_route_assoc"
  environment                = var.environment
  vpc_id                     = var.vpc_id
  availability_zone          = "eu-central-1c"
  public_subnet_cidr         = var.public_subnet_cidr
  private_app_subnet_cidr    = var.private_app_subnet_cidr
  private_db_subnet_cidr     = var.private_db_subnet_cidr
  private_consul_subnet_cidr = var.private_consul_subnet_cidr

}

#security group module will add rules for resourses created in EC2_instances module
module "security_groups" {
  source      = "./modules/security_groups"
  vpc_id      = var.vpc_id
  environment = var.environment
}

#EC2_instance module creates EC2 instanses for LB/WEB(auto_scaling)/DB/Consul
module "EC2_instances" {
  source                   = "./modules/ec2"
  environment              = var.environment
  ami_id                   = var.ami_id
  ami_id_db                = var.ami_id_db
  instance_type            = var.instance_type
  vpc_id                   = var.vpc_id
  key_name                 = var.key_name
  webapp_sg_id             = module.security_groups.webapp_sg_id
  nginx_lb_sg_id           = module.security_groups.nginx_lb_sg_id
  consul_sg_id             = module.security_groups.consul_sg_id
  database_sg_id           = module.security_groups.database_sg_id
  private_webapp_subnet_id = module.Network.private_webapp_subnet_id
  public_lb_subnet_id      = module.Network.public_lb_subnet_id
  private_db_subnet_id     = module.Network.private_db_subnet_id
  private_consul_subnet_id = module.Network.private_consul_subnet_id
  webapp_profile_name      = module.iam.webapp_profile_name
  ssm_instance_profile_name = module.iam.ssm_instance_profile_name
}