terraform {
  backend "s3" {
    bucket         = "jenkinstfstate-oreo"
    key            = "jenkins/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "jenkins_DT"
    use_lockfile   = true
  }
}