variable "environment" {
  description = "The deployment environment DEV/STAGE."
  type        = string
}

variable "vpc_id" {
  description = "The VPC id of existing VPC-Main"
  type        = string
}

variable "availability_zone" {
  description = "The availaty zone where subnet will be placed"
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

variable "instance_type" {
  description = "The EC2 instance type. Includes Jenkins requirements"
  type        = string
}