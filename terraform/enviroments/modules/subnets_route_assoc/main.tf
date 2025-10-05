# Using existing VPC for all resorses
data "aws_vpc" "main" {
    id = var.vpc_id
}

#--------Subnets

#Public subnet for LB
resource "aws_subnet" "public_lb" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = true
  availability_zone       = var.availability_zone

  tags = {
    Name        = "${var.environment}-public-lb-subnet"
    Environment = var.environment
  }
}

#Private subnet for WEB with access to NAT
resource "aws_subnet" "private_webapp" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.private_app_subnet_cidr
  map_public_ip_on_launch = false
  availability_zone       = var.availability_zone

  tags = {
    Name        = "${var.environment}-private-webapp-subnet"
    Environment = var.environment
  }
}

#Private subnet for DB without NAT
resource "aws_subnet" "private_db" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.private_db_subnet_cidr
  map_public_ip_on_launch = false
  availability_zone       = var.availability_zone

  tags = {
    Name        = "${var.environment}-private-db-subnet"
    Environment = var.environment
  }
}

#Private subnet for Consul with NAT
resource "aws_subnet" "private_consul" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.private_consul_subnet_cidr
  map_public_ip_on_launch = false
  availability_zone       = var.availability_zone

  tags = {
    Name        = "${var.environment}-private-consul-subnet"
    Environment = var.environment
  }
}

#--------------IGW
# resource "aws_internet_gateway" "main" {
#   vpc_id = var.vpc_id

#   tags = {
#     Name        = "${var.environment}-IGW"
#     Environment = var.environment
#   }
# }

data "aws_internet_gateway" "main" {
  filter {
    name   = "tag:Name"
    values = ["IGW"]
  }
}

# data "aws_nat_gateway" "main" {
#     filter {
#     name   = "tag:Name"
#     values = ["NAT-gateway"]
#   }
# }


#NAT Gateway in private subnet 
resource "aws_nat_gateway" "main" {
  connectivity_type = "private"
  subnet_id         = aws_subnet.private_consul.id
    tags = {
    Name        = "${var.environment}-nat-gateway"
    Environment = var.environment
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
    Name        = "${var.environment}-public-rt"
    Environment = var.environment
  }
}

#Public route table assosiation
resource "aws_route_table_association" "public_ld_assoc" {
  subnet_id      = aws_subnet.public_lb.id
  route_table_id = aws_route_table.public.id
}


#Private route table for DB no NAT
resource "aws_route_table" "database_private" {
  vpc_id = var.vpc_id

  tags = {
    Name        = "${var.environment}-db-rt"
    Environment = var.environment
  }
}

#Private role table association for DB no NAT
resource "aws_route_table_association" "private_db_assoc" {
  subnet_id      = aws_subnet.private_db.id
  route_table_id = aws_route_table.database_private.id
}


# Private Route Table for WEB, Consul with NAT
resource "aws_route_table" "private" {
  vpc_id = var.vpc_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }

  tags = {
    Name        = "${var.environment}-private-web-consul-rt"
    Environment = var.environment
  }
}

#Private role table association for WEB Consul цшер NAT
resource "aws_route_table_association" "private_webapp_assoc" {
  subnet_id      = aws_subnet.private_webapp.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_consul_assoc" {
  subnet_id      = aws_subnet.private_consul.id
  route_table_id = aws_route_table.private.id
}