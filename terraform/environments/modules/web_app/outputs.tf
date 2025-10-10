output "private_webapp_subnet_id" {
  description = "Private Webapp subnet id"
  value       = aws_subnet.private_webapp.id
}

output "webapp_sg_id" {
  description = "Webapp security group id"
  value       = aws_security_group.webapp.id
}

output "aws_launch_template_id" {
  description = "The launch templane id for autoscaling group"
  value       = aws_launch_template.webapp.id
}

output "aws_autoscaling_group_id" {
  description = "The id of webapp autoscaling group"
  value       = aws_autoscaling_group.webapp.id
}

output "webapp_count" {
  description = "The number of desired webapp instances in autoscaling group"
  value       = aws_autoscaling_group.webapp.desired_capacity
}

output "web-consul-rt" {
  description = "The shared route for web and consul"
  value       = aws_route_table.private.id
}