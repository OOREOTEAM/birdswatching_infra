output "private_consul_subnet_id" {
  description = "Private Consul subnet id"
  value       = aws_subnet.private_consul.id
}

output "consul_sg_id" {
  description = "Consul security group id"
  value       = aws_security_group.consul.id
}

output private_ip {
  description = "Consul private ip"
  value=aws_instance.consul.private_ip
}