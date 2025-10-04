variable "ami" {
  description = "The ami version"
  type        = string
  default     = "ami-08697da0e8d9f59ec"
}

variable "instance_type" {
  description = "The EC2 instance type. Includes Jenkins requirements"
  type        = string
  default     = "c7i-flex.large"
}

variable "subnet_id" {
  description = "The id of subnet where resourse willl be placed, private/public"
  type        = string
}

variable "SG_SubnetJenkins_id" {
  description = "Security group id for Jenkins EC2 instance"
  type        = string
}

variable "service_name" {
  description = "The EC2 instance name, will added to the tag"
  type        = string
}