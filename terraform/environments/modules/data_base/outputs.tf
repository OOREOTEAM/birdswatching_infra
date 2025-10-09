output "private_db_subnet_id" {
  description = "Private DB subnet id"
  value       = aws_subnet.private_db.id
}

output "database_sg_id" {
  description = "Database security group id"
  value       = aws_security_group.database.id
}
