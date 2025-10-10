variable "common_config" {
  description = "Common configuration settings for all modules"
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


variable "public_subnet_cidr" {
  description = "The CIDR block for the public LB subnet"
  type        = string
}

variable "private_app_subnet_cidr" {
  description = "The CIDR block for the private webapp subnet"
  type        = string
}

variable "private_db_subnet_cidr" {
  description = "The CIDR block for the private database subnet"
  type        = string
}

variable "private_consul_subnet_cidr" {
  description = "The CIDR block for the private consul subnet"
  type        = string
}

variable "ami_id" {
  description = "The ami version"
  type        = string
}

variable "ami_id_db" {
  description = "The ami version with Postgre installed"
  type        = string
}

variable "webapp_count" {
  description = "The number of desired webapp instances in autoscaling group"
  type        = string
}
