terraform {
  backend "s3" {
    bucket         = "jenkinstfstate-oreo"
    region         = "eu-central-1"
    dynamodb_table = "jenkins_DT"
    use_lockfile   = true
  }
}