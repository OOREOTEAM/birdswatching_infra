output "webapp_profile_name" {
  description = "The name of instance_profile to attach S3 and SSM policy to web instances"
  value       = module.iam.webapp_profile_name
}

output "ssm_instance_profile_name" {
  description = "The name of instance_profile to attach SSM policy to all instances"
  value       = module.iam.ssm_instance_profile_name
}

output "s3_bucket_pictures_id" {
  description = "The id of pictures s3 bucket"
  value       = module.s3_bucket_pictures.s3_bucket_pictures_id
}

output "s3_bucket_pictures_arn" {
  description = "The S3 bucket ARN"
  value       = module.s3_bucket_pictures.s3_bucket_pictures_arn
}

output "public_lb_subnet_id" {
  description = "Public LB subnet id"
  value       = module.load_balancer.public_lb_subnet_id
}

output "aws_nat_gateway_id" {
  description = "The id of stage NAT for webapp and consul"
  value       = module.load_balancer.aws_nat_gateway_id
}

output "aws_security_group_nginx" {
  description = "The if of load balancer security group"
  value       = module.load_balancer.aws_security_group_nginx
}

output "lb_eip" {
  description = "Load balancer static public IP"
  value       = module.load_balancer.lb_eip
}

output "private_webapp_subnet_id" {
  description = "Private Webapp subnet id"
  value       = module.webapp_autoscaling_group.private_webapp_subnet_id
}

output "webapp_sg_id" {
  description = "Webapp security group id"
  value       = module.webapp_autoscaling_group.webapp_sg_id
}

output "aws_launch_template_id" {
  description = "The launch templane id for autoscaling group"
  value       = module.webapp_autoscaling_group.aws_launch_template_id
}

output "aws_autoscaling_group_id" {
  description = "The id of webapp autoscaling group"
  value       = module.webapp_autoscaling_group.aws_launch_template_id
}

output "webapp_count" {
  description = "The number of desired webapp instances in autoscaling group"
  value       = module.webapp_autoscaling_group.webapp_count
}

output "private_db_subnet_id" {
  description = "Private DB subnet id"
  value       = module.database.private_db_subnet_id
}

output "database_sg_id" {
  description = "Database security group id"
  value       = module.database.database_sg_id
}

output "private_consul_subnet_id" {
  description = "Private Consul subnet id"
  value       = module.consul.private_consul_subnet_id
}

output "consul_sg_id" {
  description = "Consul security group id"
  value       = module.consul.consul_sg_id
}
