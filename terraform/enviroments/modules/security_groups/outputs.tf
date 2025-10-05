output "nginx_lb_sg_id" {
  value = aws_security_group.nginx_lb.id
}

output "webapp_sg_id" {
  value = aws_security_group.webapp.id
}

output "database_sg_id" {
  value = aws_security_group.database.id
}

output "consul_sg_id" {
  value = aws_security_group.database.id
}