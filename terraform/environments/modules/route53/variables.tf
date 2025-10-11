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

variable "consul_ip" {
  description = "consul_ip"
  type = string
    
}