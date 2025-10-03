variable "ami" {
  default = "ami-08697da0e8d9f59ec"
}

variable "instance_type" {
  description = "The EC2 instance type. Includes Jenkins requirements"
  type = string
  default = "c7i-flex.large"
}

variable "key_name" {
  default = "jenkins_key"
}

variable "subnet_id" {}

variable "SG_SubnetJenkins_id" {}

variable "servise_name" {}