terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.aws_region
}

module "network" {
  source = "./modules/network"
}


module "security_group" {
  source = "./modules/security_group"
  vpc_id = module.network.vpc_id
}

module "jenkins_server" {
  source              = "./modules/ec2"
  subnet_id           = module.network.subnet_id_private
  SG_SubnetJenkins_id = module.security_group.SG_SubnetJenkins_id
  service_name        = "Jenkins"
}
