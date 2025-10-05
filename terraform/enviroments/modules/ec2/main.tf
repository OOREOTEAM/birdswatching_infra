#LoadBalancer

resource "aws_instance" "nginx_lb" {
  ami                         = var.ami_id
  instance_type               = "t3.micro"
  subnet_id                   = var.public_lb_subnet_id
  vpc_security_group_ids      = [var.nginx_lb_sg_id]
  associate_public_ip_address = true

  tags = {
    Name        = "${var.environment}-nginx-load-balancer"
    Environment = var.environment
  }
}


#Creating webapp servers using launch templates for autoscaling
resource "aws_launch_template" "webapp" {
  name_prefix   = "${var.environment}-webapp-"
  image_id      = var.ami_id
  instance_type = var.instance_type

  vpc_security_group_ids = [var.webapp_sg_id]

  tags = {
    Name        = "${var.environment}-webapp-instance"
    Environment = var.environment
  }
}

resource "aws_autoscaling_group" "webapp" {
  name                = "${var.environment}-webapp-asg"
  vpc_zone_identifier = [var.private_webapp_subnet_id]
  desired_capacity    = 2
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


#Creating DB server
resource "aws_instance" "database" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.private_db_subnet_id
  vpc_security_group_ids = [var.database_sg_id]

  tags = {
    Name        = "${var.environment}-database-instance"
    Environment = var.environment
  }
}

#Creating consul server
resource "aws_instance" "consul" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.private_consul_subnet_id
  vpc_security_group_ids = [var.consul_sg_id]

  tags = {
    Name        = "${var.environment}-consul-instance"
    Environment = var.environment
  }
}
