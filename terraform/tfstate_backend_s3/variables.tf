variable "aws_region" {
  description = "The AWS region where all resouses created"
  type = string
  default = "eu-central-1"
}

variable "bucket_name" {
  default = "jenkinstfstate-oreo"
}

variable "dynamodb_table_name" {
  default = "jenkins_DT"
}