terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    datadog = {
      source  = "DataDog/datadog"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "eu-central-1"

  default_tags {
    tags = {
      Environment = var.common_config.environment
      Project     = "BirdWatching"
    }
  }
}

provider "datadog" {
  api_key = local.datadog_keys.api_keyS
  app_key = local.datadog_keys.app_key
}

data "aws_secretsmanager_secret_version" "datadog_creds" {
  secret_id = "arn:aws:secretsmanager:eu-central-1:455185968385:secret:datadog/keys-kA5yxk" 
}

locals {
  datadog_keys = jsondecode(data.aws_secretsmanager_secret_version.datadog_creds.secret_string)
}

resource "aws_ssm_document" "install_datadog_agent" {
  name          = "InstallDataDogAgent-Script"
  document_type = "Command"
  content = jsonencode({
    schemaVersion = "2.2"
    description   = "Install DataDog Agent"
    mainSteps = [
      {
        action = "aws:runCommand"
        name   = "installDataDogAgent"
        inputs = {
          DocumentName = "AWS-RunShellScript"
          Parameters = {
            commands = [
              "DD_API_KEY=${local.datadog_keys.api_key} DD_SITE=\"datadoghq.eu\" DD_REMOTE_UPDATES=true \\ bash -c \"$(curl -L https://install.datadoghq.com/scripts/install_script_agent7.sh)\""
            ]
          }
        }
      }
    ]
  })
}

resource "aws_ssm_association" "install_datadog_on_all" {
  name = aws_ssm_document.install_datadog_agent.name
  targets {
    key    = "tag:Name"
    values = [ 
    "${var.common_config.environment}-webapp-asg-instance", 
    "${var.common_config.environment}-db-instance", 
    "${var.common_config.environment}-consul-instance",
    "${var.common_config.environment}-webapp-instance",
    "${var.common_config.environment}-nginx-load-balancer"
    ]
  }
}

#The s3_bucket_pictures includes creation of S3 bucket for webapp
module "s3_bucket_pictures" {
  source      = "./modules/s3_bucket_pictures"
  environment = var.common_config.environment
}

#The IAM module creates rule for webapp to access S3 bucket and SSM manager for all instances 
module "iam" {
  source                 = "./modules/iam"
  environment            = var.common_config.environment
  s3_bucket_pictures_arn = module.s3_bucket_pictures.s3_bucket_pictures_arn
}

#The module for load balance service creation
module "load_balancer" {
  source                     = "./modules/load_balancer"
  common_config              = var.common_config
  ami_id                     = var.ami_id
  igw_id                     = var.igw_id
  public_subnet_cidr         = var.public_subnet_cidr
  private_consul_subnet_cidr = var.private_consul_subnet_cidr
  ssm_instance_profile_name  = module.iam.ssm_instance_profile_name
}

#The module for webapp service creation 
module "webapp_autoscaling_group" {
  source                     = "./modules/web_app"
  common_config              = var.common_config
  ami_id                     = var.ami_id
  igw_id                     = var.igw_id
  webapp_count               = var.webapp_count
  security_group_nginx       = module.load_balancer.aws_security_group_nginx
  public_subnet_cidr         = var.public_subnet_cidr
  private_app_subnet_cidr    = var.private_app_subnet_cidr
  private_consul_subnet_cidr = var.private_consul_subnet_cidr
  nat_gateway_id             = module.load_balancer.aws_nat_gateway_id
  webapp_profile_name        = module.iam.webapp_profile_name
}

#The module for database service creation 
module "database" {
  source                     = "./modules/database"
  common_config              = var.common_config
  ami_id_db                  = var.ami_id_db
  webapp_sg_id               = module.webapp_autoscaling_group.webapp_sg_id
  private_consul_subnet_cidr = var.private_consul_subnet_cidr
  nat_gateway_id             = module.load_balancer.aws_nat_gateway_id
  private_db_subnet_cidr     = var.private_db_subnet_cidr
  ssm_instance_profile_name  = module.iam.ssm_instance_profile_name
}

#The module for consul service creation 
module "consul" {
  source                     = "./modules/consul"
  common_config              = var.common_config
  ami_id                     = var.ami_id
  web-consul-rt              = module.webapp_autoscaling_group.web-consul-rt
  private_consul_subnet_cidr = var.private_consul_subnet_cidr
  ssm_instance_profile_name  = module.iam.ssm_instance_profile_name
}

#The module for PrivateDNS service creation 
module "route53" {
  source        = "./modules/route53"
  common_config = var.common_config
  consul_ip     = module.consul.private_ip
}


