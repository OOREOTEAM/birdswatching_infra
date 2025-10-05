variable "environment" {
  description = "The deployment environment DEV/STAGE."
  type        = string
}

variable "vpc_id" {
  description = "The VPC id of existing VPC-Main"
  type        = string
}
