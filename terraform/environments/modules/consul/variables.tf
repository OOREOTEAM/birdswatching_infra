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

variable "ami_id" {
  description = "The ami version"
  type        = string
}

variable "private_consul_subnet_cidr" {
  description = "The CIDR block for the private consul subnet"
  type        = string
}

variable "web-consul-rt" {
  description = "The shared route for web and consul"
  type        = string
}

variable "ssm_instance_profile_name" {
  description = "The name of instance_profile to attach SSM policy to all instances"
  type        = string
}
