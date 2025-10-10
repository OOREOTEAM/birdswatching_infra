
output "iam_roles" {
  description = "The name of instance_profile to attach policies to instances"
  value = {
    webapp_profile_name = module.iam.webapp_profile_name
    ssm_role_name       = module.iam.ssm_instance_profile_name
  }
}


output "s3_bucket_pictures" {
  description = "Properties of the pictures S3 bucket"
  value = {
    id  = module.s3_bucket_pictures.s3_bucket_pictures_id
    arn = module.s3_bucket_pictures.s3_bucket_pictures_arn
  }
}


output "load_balancer_info" {
  description = "Properties of load balancer instance"
  value = {
    lb_eip           = module.load_balancer.lb_eip
    public_subnet_id = module.load_balancer.public_lb_subnet_id
    nat_gateway_id   = module.load_balancer.aws_nat_gateway_id
    security_group   = module.load_balancer.aws_security_group_nginx
  }
}

output "webapp_info" {
  description = "Properties of load balancer instance"
  value = {
    private_subnet_id = module.webapp_autoscaling_group.private_webapp_subnet_id
    security_group    = module.webapp_autoscaling_group.webapp_sg_id
  }
}

output "database_info" {
  description = "Properties of load balancer instance"
  value = {
    private_subnet_id = module.database.private_db_subnet_id
    security_group    = module.database.database_sg_id
  }
}


output "consul_info" {
  description = "Properties of load balancer instance"
  value = {
    private_subnet_id = module.consul.private_consul_subnet_id
    security_group    = module.consul.consul_sg_id
  }
}

