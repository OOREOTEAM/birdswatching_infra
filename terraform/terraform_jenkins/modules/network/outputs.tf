output "vpc_id" {
  value = aws_vpc.main_vpc.id
}

output "gw_main" {
  value = aws_internet_gateway.gw_main.id
}

output "subnet_id_public" {
  value = aws_subnet.public.id
}

output "subnet_id_private" {
  value = aws_subnet.private.id
}
