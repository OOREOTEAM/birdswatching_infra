
data "aws_vpc" "main" {
    id = var.vpc_id
}

#Using existing Jenkins security group for Consul sg
data "aws_security_group" "jenkins_sg"{
  filter {
    name   = "tag:Name"
    values = ["Jenkins-Consul-SG"]
  }
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
    security_groups = [data.aws_security_group.jenkins_sg.id] #allow trafic from jenkins
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
    security_groups = [aws_security_group.nginx_lb.id] #allow trafic from lb
  }
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [data.aws_security_group.jenkins_sg.id] #allow trafic from jenkins
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


#security group for Consul
resource "aws_security_group" "consul" {
  name        = "${var.environment}-consul-sg"
  description = "Allow Consul traffic from within the VPC"
  vpc_id      = var.vpc_id

  #Allow DNS queries within the VPC for service discovery
  ingress {
    description = "Consul DNS"
    from_port   = 8600
    to_port     = 8600
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.main.cidr_block]
  }

  ingress {
    description = "Consul DNS"
    from_port   = 8600
    to_port     = 8600
    protocol    = "udp"
    cidr_blocks = [data.aws_vpc.main.cidr_block]
  }

  # Allow HTTP API access from the WebApp instances
  ingress {
    description     = "Consul HTTP API"
    from_port       = 8500
    to_port         = 8500
    protocol        = "tcp"
    security_groups = [aws_security_group.webapp.id]
  }

  # Allow HTTPS API  access from the WebApp instances
  ingress {
    description     = "Consul HTTPS API"
    from_port       = 8501
    to_port         = 8501
    protocol        = "tcp"
    security_groups = [aws_security_group.webapp.id]
  }

  # Allow Server RPC traffic for Consul internal communication with servers
  ingress {
    description              = "Consul Server RPC"
    from_port                = 8300
    to_port                  = 8300
    protocol                 = "tcp"
    self                     = true
  }

  # Allow LAN Serf for The Serf local area network port
  ingress {
    description              = "Consul LAN Serf"
    from_port                = 8301
    to_port                  = 8301
    protocol                 = "tcp"
    self                     = true
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [data.aws_security_group.jenkins_sg.id]
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
      
    ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [data.aws_security_group.jenkins_sg.id]
  }

    ingress {
    description     = "Consul HTTP API"
    from_port       = 8500
    to_port         = 8500
    protocol        = "tcp"
    security_groups = [aws_security_group.consul.id]
  }

    ingress {
    description     = "Consul DNC"
    from_port       = 8600
    to_port         = 8600
    protocol        = "tcp"
    security_groups = [aws_security_group.consul.id]
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

#Using separate security groups to fix issue with cycle

#Allow access consul to ld
resource "aws_security_group_rule" "consul_to_nginx_http" {
  type                     = "ingress"
  security_group_id        = aws_security_group.nginx_lb.id
  source_security_group_id = aws_security_group.consul.id
  from_port                = 8500
  to_port                  = 8500
  protocol                 = "tcp"
}

#Allow access consul to webapp
resource "aws_security_group_rule" "consul_to_nginx_dnc" {
  type                     = "ingress"
  security_group_id        = aws_security_group.nginx_lb.id
  source_security_group_id = aws_security_group.consul.id
  from_port                = 8600
  to_port                  = 8600
  protocol                 = "tcp"
}


#Allow access consul to webapp
resource "aws_security_group_rule" "consul_to_webapp_http" {
  type                     = "ingress"
  security_group_id        = aws_security_group.webapp.id
  source_security_group_id = aws_security_group.consul.id
  from_port                = 8500
  to_port                  = 8500
  protocol                 = "tcp"
}

resource "aws_security_group_rule" "consul_to_webapp_dnc" {
  type                     = "ingress"
  security_group_id        = aws_security_group.webapp.id
  source_security_group_id = aws_security_group.consul.id
  from_port                = 8600
  to_port                  = 8600
  protocol                 = "tcp"
}

