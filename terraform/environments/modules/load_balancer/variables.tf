variable "environment" {
  description = "The deployment environment dev/stage"
  type        = string
}

variable "vpc_id" {
  description = "The VPC id of existing VPC-Main where all resources will be created"
  type        = string
}

variable "igw_id" {
  description = "The existing internet gateway id"
  type        = string
}

variable "jenkins_sg" {
  description = "The existing jenkins security group id to apply inbount rules on 22 port"
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

variable "private_consul_subnet_cidr" {
  description = "The CIDR block for the private consul subnet"
  type        = string
}

variable "ami_id" {
  description = "The ami version"
  type        = string
}


variable "instance_type" {
  description = "The EC2 instance type"
  type        = string
}

variable "ssm_instance_profile_name" {
  description = "The name of instance_profile to attach SSM policy to all instances"
  type        = string
}

variable "key_name" {
  description = "Key pair to attach to ec2 instanse, to have shh connection"
  type        = string
}