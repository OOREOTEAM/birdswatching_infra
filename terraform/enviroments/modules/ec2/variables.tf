variable "ami_id" {
  description = "The ami version"
  type        = string
}

variable "instance_type" {
  description = "The EC2 instance type. Includes Jenkins requirements"
  type        = string
}

variable "environment" {
  description = "The deployment environment DEV/STAGE."
  type        = string
}

variable "vpc_id" {
  description = "The VPC id of existing VPC-Main"
  type        = string
}

variable "public_lb_subnet_id" {
  description = "LB public subnet id"
  type        = string
}

variable "nginx_lb_sg_id" {
  description = "LB security group id"
  type        = string
}

variable "webapp_sg_id" {
  description = "WebApp security group id"
  type        = string
}

variable "private_webapp_subnet_id" {
  description = "WebApp private subnet id"
  type        = string
}

variable "database_sg_id" {
  description = "DataBase security group id"
  type        = string
}

variable "private_db_subnet_id" {
  description = "DataBase private subnet id"
  type        = string
}

variable "consul_sg_id" {
  description = "Consul security group id"
  type        = string
}

variable "private_consul_subnet_id" {
  description = "Consul private subnet id"
  type        = string
}
