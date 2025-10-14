variable "common_config" {
  description = "Common configuration values for module"
  type = object({
    environment       = string
    vpc_id            = string
    key_name          = string
    availability_zone = string
    jenkins_sg        = string
    instance_type     = string
  })
}

variable "private_db_subnet_cidr" {
  description = "The CIDR block for the private database subnet"
  type        = string
}

variable "private_consul_subnet_cidr" {
  description = "The CIDR block for the private consul subnet"
  type        = string
}

variable "webapp_sg_id" {
  description = "Webapp security group id"
  type        = string
}

variable "ami_id_db" {
  description = "The ami version with Postgre installed"
  type        = string
}

variable "ssm_instance_profile_name" {
  description = "The name of instance_profile to attach SSM policy to all instances"
  type        = string
}

variable "nat_gateway_id" {
  description = "The id of dedicated enviroment NAT"
  type        = string
}