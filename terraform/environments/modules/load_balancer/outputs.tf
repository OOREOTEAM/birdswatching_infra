output "public_lb_subnet_id" {
  description = "Public LB subnet id"
  value       = aws_subnet.public_lb.id
}

output "aws_nat_gateway_id" {
  description = "The id of stage NAT for webapp and consul"
  value       = aws_nat_gateway.main.id
}

output "aws_security_group_nginx" {
  description = "The if of load balancer security group"
  value       = aws_security_group.nginx_lb.id
}

output "lb_eip" {
  description = "Load balancer static public IP"
  value       = aws_eip.lb_eip.public_ip
}