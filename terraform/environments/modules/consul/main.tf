# Using existing VPC for all resorses
data "aws_vpc" "main" {
  id = var.vpc_id
}

#Using existing Jenkins security group
data "aws_security_group" "jenkins_sg" {
  id = var.jenkins_sg

}

#Private subnet for Consul with NAT
resource "aws_subnet" "private_consul" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.private_consul_subnet_cidr
  map_public_ip_on_launch = false
  availability_zone       = var.availability_zone

  tags = {
    Name = "${var.environment}-private-consul-subnet"
  }
}

#Private role table association for WEB Consul with NAT
resource "aws_route_table_association" "private_consul_assoc" {
  subnet_id      = aws_subnet.private_consul.id
  route_table_id = var.web-consul-rt
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

  ingress {
    description = "Consul HTTP API"
    from_port   = 8500
    to_port     = 8500
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.main.cidr_block]
  }

  ingress {
    description = "Consul HTTPS API"
    from_port   = 8501
    to_port     = 8501
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.main.cidr_block]
  }

  ingress {
    description = "Consul Server RPC"
    from_port   = 8300
    to_port     = 8300
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.main.cidr_block]
  }

  ingress {
    description = "Consul LAN Serf"
    from_port   = 8301
    to_port     = 8301
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.main.cidr_block]
  }

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [data.aws_security_group.jenkins_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.environment}-consul-sg"
  }
}

#Creating consul server
resource "aws_instance" "consul" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.private_consul.id
  vpc_security_group_ids = [aws_security_group.consul.id]
  iam_instance_profile   = var.ssm_instance_profile_name
  key_name               = var.key_name

  tags = {
    Name = "${var.environment}-consul-instance"
  }
}
