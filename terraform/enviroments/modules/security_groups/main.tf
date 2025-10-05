
data "aws_vpc" "main" {
    id = var.vpc_id
}

#Security group for LB
resource "aws_security_group" "nginx_lb" {
  name        = "${var.environment}-nginx-lb-sg"
  description = "Allow inbound HTTP/S and SSH traffic to Nginx LB"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.environment}-nginx-lb-sg"
    Environment = var.environment
  }
}

#security_group for web
resource "aws_security_group" "webapp" {
  name        = "${var.environment}-webapp-sg"
  description = "Allow traffic from LB and to DB"
  vpc_id      = var.vpc_id

  
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.nginx_lb.id]
  }
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.environment}-webapp-sg"
    Environment = var.environment
  }
}

#security_group for DB
resource "aws_security_group" "database" {
  name        = "${var.environment}-database-sg"
  description = "Allow PostgreSQL traffic from the webapp security group"
  vpc_id      = var.vpc_id


  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.webapp.id] #WebApp security group
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.environment}-database-sg"
    Environment = var.environment
  }
}


#security group for Consul
resource "aws_security_group" "consul" {
  name        = "${var.environment}-consul-sg"
  description = "Allow Consul traffic from within the VPC"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [data.aws_vpc.main.cidr_block] #traffic within the VPC for service discovery
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.environment}-consul-sg"
    Environment = var.environment
  }
}
