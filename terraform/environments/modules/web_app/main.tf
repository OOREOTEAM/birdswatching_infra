# Using existing VPC for all resorses
data "aws_vpc" "main" {
  id = var.vpc_id
}

#Using existing IGW
data "aws_internet_gateway" "main" {
  internet_gateway_id = var.igw_id
}

#Using existing Jenkins security group
data "aws_security_group" "jenkins_sg" {
  id = var.jenkins_sg

}

#Private subnet for WEB with access to NAT
resource "aws_subnet" "private_webapp" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.private_app_subnet_cidr
  map_public_ip_on_launch = false
  availability_zone       = var.availability_zone

  tags = {
    Name = "${var.environment}-private-webapp-subnet"
  }
}

# Private Route Table for WEB, Consul with NAT
resource "aws_route_table" "private" {
  vpc_id = var.vpc_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = var.nat_gateway_id
  }

  tags = {
    Name = "${var.environment}-private-web-consul-rt"
  }
}

#Private role table association for WEB
resource "aws_route_table_association" "private_webapp_assoc" {
  subnet_id      = aws_subnet.private_webapp.id
  route_table_id = aws_route_table.private.id
}



#Security_group for web
resource "aws_security_group" "webapp" {
  name        = "${var.environment}-webapp-sg"
  description = "Allow traffic from LB and to DB"
  vpc_id      = var.vpc_id


  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.public_subnet_cidr] #allow trafic from lb
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
    Name = "${var.environment}-webapp-sg"
  }
}


#Creating webapp servers using launch templates for autoscaling
resource "aws_launch_template" "webapp" {
  name_prefix            = "${var.environment}-webapp-"
  image_id               = var.ami_id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.webapp.id]
  key_name               = var.key_name

  iam_instance_profile {
    name = var.webapp_profile_name
  }

  tags = {
    Name = "${var.environment}-webapp-instance"
  }
}

resource "aws_autoscaling_group" "webapp" {
  name                = "${var.environment}-webapp-asg"
  vpc_zone_identifier = [aws_subnet.private_webapp.id]
  desired_capacity    = var.webapp_count
  max_size            = 2
  min_size            = 1

  launch_template {
    id      = aws_launch_template.webapp.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.environment}-webapp-asg-instance"
    propagate_at_launch = true
  }
}