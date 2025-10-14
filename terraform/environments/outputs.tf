
output "load_balancer_info" {
  description = "Properties of load balancer instance"
  value = {
    lb_eip           = module.load_balancer.lb_eip
    public_subnet_id = module.load_balancer.public_lb_subnet_id
    nat_gateway_id   = module.load_balancer.aws_nat_gateway_id
    security_group   = module.load_balancer.aws_security_group_nginx
  }
}

