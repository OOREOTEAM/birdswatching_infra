# # Using existing VPC for all resorses
data "aws_vpc" "main" {
  id = var.common_config.vpc_id
}

#Using existing Jenkins security group
data "aws_security_group" "jenkins_sg" {
  id = var.common_config.jenkins_sg

}
#Private subnet for DB without NAT
resource "aws_subnet" "private_db" {
  vpc_id                  = var.common_config.vpc_id
  cidr_block              = var.private_db_subnet_cidr
  map_public_ip_on_launch = false
  availability_zone       = var.common_config.availability_zone

  tags = {
    Name = "${var.common_config.environment}-private-db-subnet"
  }
}

#Private route table for DB no NAT
resource "aws_route_table" "database_private" {
  vpc_id = var.common_config.vpc_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = var.nat_gateway_id
  }

  tags = {
    Name = "${var.common_config.environment}-db-rt"
  }
}

resource "aws_route_table_association" "private_db_assoc" {
  subnet_id      = aws_subnet.private_db.id
  route_table_id = aws_route_table.database_private.id
}


#security_group for DB
resource "aws_security_group" "database" {
  name        = "${var.common_config.environment}-database-sg"
  description = "Allow PostgreSQL traffic from the webapp"
  vpc_id      = var.common_config.vpc_id


  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [var.webapp_sg_id] #allow only webApp access
  }

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [data.aws_security_group.jenkins_sg.id]
  }


  ingress {
    description = "Consul LAN Serf"
    from_port   = 8301
    to_port     = 8301
    protocol    = "udp"
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
    Name = "${var.common_config.environment}-database-sg"
  }
}


#Creating DB server
resource "aws_instance" "database" {
  ami                    = var.ami_id_db
  instance_type          = var.common_config.instance_type
  subnet_id              = aws_subnet.private_db.id
  vpc_security_group_ids = [aws_security_group.database.id]
  iam_instance_profile   = var.ssm_instance_profile_name
  key_name               = var.common_config.key_name

  ebs_block_device {
    device_name           = "/dev/sdc" #for EBS dara volumes
    volume_size           = 1
    volume_type           = "gp3"
    delete_on_termination = false #only for database to save volume after deletion
    encrypted             = true
    tags = {
      Name = "${var.common_config.environment}-database-volume"
    }

  }

  tags = {
    Name = "${var.common_config.environment}-database-instance"
  }
}