terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.aws_region # will be used for all other instances
}

# S3 bucket for jenkins tstate
resource "aws_s3_bucket" "jenkinstfstate" {
  bucket = var.bucket_name

  lifecycle {
    prevent_destroy = true
  }
}

# versioning on the S3 bucket
resource "aws_s3_bucket_versioning" "tfstate_versioning" {
  bucket = aws_s3_bucket.jenkinstfstate.id
  versioning_configuration {
    status = "Enabled"
  }
}

#DynamoDB table for state locking
resource "aws_dynamodb_table" "jenkins_DT" {
  name         = var.dynamodb_table_name
  hash_key     = "LockID"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "LockID"
    type = "S"
  }
}