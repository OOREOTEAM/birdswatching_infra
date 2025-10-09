
# Using existing VPC for all resorses
data "aws_vpc" "main" {
  id = var.vpc_id
}


#Using existing IGW
data "aws_internet_gateway" "main" {
  internet_gateway_id = var.igw_id
}


#Public subnet for LB
resource "aws_subnet" "public_lb" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = true
  availability_zone       = var.availability_zone

  tags = {
    Name = "${var.environment}-public-lb-subnet"
  }
}


#Elastic IP for enviroment NAT
resource "aws_eip" "nat_eip" {
  domain     = "vpc"
  depends_on = [data.aws_internet_gateway.main]
  tags = {
    Name = "${var.environment}-nat-eip"
  }
}


#NAT Gateway in public lb subnet 
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_lb.id
  tags = {
    Name = "${var.environment}-nat-gateway"
  }
  depends_on = [data.aws_internet_gateway.main]
}

#------------Route tables and assosiation

#Public route table with LB
resource "aws_route_table" "public" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = data.aws_internet_gateway.main.id
  }

  tags = {
    Name = "${var.environment}-public-rt"
  }
}

#Public route table assosiation
resource "aws_route_table_association" "public_ld_assoc" {
  subnet_id      = aws_subnet.public_lb.id
  route_table_id = aws_route_table.public.id
}


#------Security group

#Using existing Jenkins security group
data "aws_security_group" "jenkins_sg" {
  id = var.jenkins_sg

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
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [data.aws_security_group.jenkins_sg.id] #allow trafic from jenkins
  }

  #Ingress rules for Consul using consul cidr_block
  ingress {
    description = "Consul DNS"
    from_port   = 8600
    to_port     = 8600
    protocol    = "tcp"
    cidr_blocks = [var.private_consul_subnet_cidr]
  }

  ingress {
    description = "Consul DNS"
    from_port   = 8600
    to_port     = 8600
    protocol    = "udp"
    cidr_blocks = [var.private_consul_subnet_cidr]
  }

  ingress {
    description = "Consul HTTP API"
    from_port   = 8500
    to_port     = 8500
    protocol    = "tcp"
    cidr_blocks = [var.private_consul_subnet_cidr]
  }

  ingress {
    description = "Consul HTTPS API"
    from_port   = 8501
    to_port     = 8501
    protocol    = "tcp"
    cidr_blocks = [var.private_consul_subnet_cidr]
  }


  ingress {
    description = "Consul Server RPC"
    from_port   = 8300
    to_port     = 8300
    protocol    = "tcp"
    cidr_blocks = [var.private_consul_subnet_cidr]
  }

  ingress {
    description = "Consul LAN Serf"
    from_port   = 8301
    to_port     = 8301
    protocol    = "tcp"
    cidr_blocks = [var.private_consul_subnet_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.environment}-nginx-lb-sg"
  }
}


#LoadBalancer

resource "aws_instance" "nginx_lb" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public_lb.id
  vpc_security_group_ids      = [aws_security_group.nginx_lb.id]
  associate_public_ip_address = true
  iam_instance_profile        = var.ssm_instance_profile_name
  key_name                    = var.key_name

  tags = {
    Name = "${var.environment}-nginx-load-balancer"
  }
}

#Crating Elastic IP for load balancer
resource "aws_eip" "lb_eip" {
  domain     = "vpc"
  depends_on = [data.aws_internet_gateway.main]

  tags = {
    Name = "${var.environment}-lb-eip"
  }
}

#Attaching ip to instance
resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.nginx_lb.id
  allocation_id = aws_eip.lb_eip.id
}