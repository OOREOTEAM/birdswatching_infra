output "webapp_profile_name" {
  description = "The name of instance_profile to attach S3 and SSM policy to web instances"
  value = aws_iam_instance_profile.webapp_profile.name
}

output "ssm_instance_profile_name" {
  description = "The name of instance_profile to attach SSM policy to all instances"
  value = data.aws_iam_instance_profile.ssm_instance_profile.name
}