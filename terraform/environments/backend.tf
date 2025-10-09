terraform {
  backend "s3" {
    bucket         = "jenkinstfstate-oreo"
    key            = "environments/terraform.tfstate"
    region         = "eu-central-1"
    encrypt        = true
    dynamodb_table = "jenkins_DT"
  }
}