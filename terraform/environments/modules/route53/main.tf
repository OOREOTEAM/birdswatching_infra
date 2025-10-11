resource "aws_route53_zone" "private_zone" {
  name         = "${var.common_config.environment}.internal"
  comment      = "Private hosted zone for ${var.common_config.environment} environment"

  vpc {
    vpc_id = var.common_config.vpc_id
  }

  force_destroy = true

  tags = {
    Name = "${var.common_config.environment}-route53"
    
  }
}

# Add Consul dns record
resource "aws_route53_record" "consul" {
  zone_id = aws_route53_zone.private_zone.zone_id
  name    = "${var.common_config.environment}.consul"
  type    = "A"
  ttl     = 300
  records = [var.consul_ip]
}