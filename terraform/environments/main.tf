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

  default_tags {
    tags = {
      Environment = var.environment
      Project     = "BirdWatching"
    }
  }
}


#The s3_bucket_pictures includes creation of S3 bucket for webapp
module "s3_bucket_pictures" {
  source      = "./modules/s3_bucket_pictures"
  environment = var.environment
}

#The IAM module creates rule for webapp to access S3 bucket and SSM manager for all instances 
module "iam" {
  source                 = "./modules/iam"
  environment            = var.environment
  s3_bucket_pictures_arn = module.s3_bucket_pictures.s3_bucket_pictures_arn
}

#The module for load balance service creation
module "load_balancer" {
  source                     = "./modules/load_balancer"
  environment                = var.environment
  ami_id                     = var.ami_id
  instance_type              = var.instance_type
  vpc_id                     = var.vpc_id
  igw_id                     = var.igw_id
  jenkins_sg                 = var.jenkins_sg
  key_name                   = var.key_name
  availability_zone          = var.availability_zone
  public_subnet_cidr         = var.public_subnet_cidr
  private_consul_subnet_cidr = var.private_consul_subnet_cidr
  ssm_instance_profile_name  = module.iam.ssm_instance_profile_name
}

#The module for webapp service creation 
module "webapp_autoscaling_group" {
  source                     = "./modules/web_app"
  environment                = var.environment
  ami_id                     = var.ami_id
  instance_type              = var.instance_type
  vpc_id                     = var.vpc_id
  igw_id                     = var.igw_id
  jenkins_sg                 = var.jenkins_sg
  availability_zone          = var.availability_zone
  webapp_count               = var.webapp_count
  security_group_nginx       = module.load_balancer.aws_security_group_nginx
  public_subnet_cidr         = var.public_subnet_cidr
  private_app_subnet_cidr    = var.private_app_subnet_cidr
  private_consul_subnet_cidr = var.private_consul_subnet_cidr
  nat_gateway_id             = module.load_balancer.aws_nat_gateway_id
  webapp_profile_name        = module.iam.webapp_profile_name
  key_name                   = var.key_name
}

#The module for database service creation 
module "data_base" {
  source                     = "./modules/database"
  environment                = var.environment
  ami_id_db                  = var.ami_id_db
  instance_type              = var.instance_type
  vpc_id                     = var.vpc_id
  jenkins_sg                 = var.jenkins_sg
  availability_zone          = var.availability_zone
  webapp_sg_id               = module.webapp_autoscaling_group.webapp_sg_id
  private_consul_subnet_cidr = var.private_consul_subnet_cidr
  nat_gateway_id             = module.load_balancer.aws_nat_gateway_id
  private_db_subnet_cidr     = var.private_db_subnet_cidr
  ssm_instance_profile_name  = module.iam.ssm_instance_profile_name
  key_name                   = var.key_name
}

#The module for consul service creation 
module "consul" {
  source                     = "./modules/consul"
  environment                = var.environment
  ami_id                     = var.ami_id
  instance_type              = var.instance_type
  vpc_id                     = var.vpc_id
  jenkins_sg                 = var.jenkins_sg
  availability_zone          = var.availability_zone
  web-consul-rt              = module.webapp_autoscaling_group.web-consul-rt
  private_consul_subnet_cidr = var.private_consul_subnet_cidr
  ssm_instance_profile_name  = module.iam.ssm_instance_profile_name
  key_name                   = var.key_name

}