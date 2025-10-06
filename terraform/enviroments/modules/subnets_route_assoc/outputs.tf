output "public_lb_subnet_id" {
  description = "Public LB subnet id"
  value       = aws_subnet.public_lb.id
}

output "private_webapp_subnet_id" {
  description = "Private Webapp subnet id"
  value       = aws_subnet.private_webapp.id
}

output "private_db_subnet_id" {
  description = "Private DB subnet id"
  value       = aws_subnet.private_db.id
}

output "private_consul_subnet_id" {
  description = "Private Consul subnet id"
  value       = aws_subnet.private_consul.id
}
