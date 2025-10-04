variable "vpc_id" {}

variable "allowed_ports" {
  description = "List of allowed ports"
  type        = list(any)
  default     = ["80", "443", "22", "8080"]
}

variable "team_ips" {
  description = "The CIDR block for the private jenkins subnet"
  type        = list(any)
  default     = ["0.0.0.0/0"]
}