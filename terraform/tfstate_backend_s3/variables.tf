variable "aws_region" {
  description = "The AWS region where all resouses created"
  type        = string
  default     = "eu-central-1"
}

variable "bucket_name" {
  description = "S3 bucket name"
  type        = string
  default     = "jenkinstfstate-oreo"
}

variable "dynamodb_table_name" {
  description = "Dynamo table name"
  type        = string
  default     = "jenkins_DT"
}