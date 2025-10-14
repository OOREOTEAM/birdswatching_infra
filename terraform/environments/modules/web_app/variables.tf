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

variable "igw_id" {
  description = "The existing internet gateway id"
  type        = string
}

variable "ami_id" {
  description = "The ami version"
  type        = string
}

variable "private_app_subnet_cidr" {
  description = "The CIDR block for the private webapp subnet"
  type        = string
}

variable "nat_gateway_id" {
  description = "The id of dedicated enviroment NAT for webapp and consul"
  type        = string
}

variable "security_group_nginx" {
  description = "The if of load balancer security group"
  type        = string
}

variable "public_subnet_cidr" {
  description = "The CIDR block for the public LB subnet"
  type        = string
}

variable "webapp_profile_name" {
  description = "The name of instance_profile to attach S3 and SSM policy to web instances"
  type        = string
}

variable "webapp_count" {
  description = "The number of desired webapp instances in autoscaling group"
  type        = string
}

variable "private_consul_subnet_cidr" {
  description = "The CIDR block for the private consul subnet"
  type        = string
}