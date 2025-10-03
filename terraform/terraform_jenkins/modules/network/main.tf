#VPC
resource "aws_vpc" "main_vpc" {
  cidr_block = var.vpc_cidr
  instance_tenancy = "default"
  
  tags = {
    Name = var.vpc_name
  }
}

#Public subnet
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet"
  }
}

#Private subnet
resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = var.private_subnet_cidr
  tags = {
    Name = "private-subnet-Jenkins"
  }
}


# Internet Gateway
resource "aws_internet_gateway" "gw_main" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name = "IGW"
  }
}


#Elastic IP
resource "aws_eip" "nat_eip" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.gw_main]
}

#NAT in public subnet
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public.id
  tags = {
    Name = "NAT-gateway"
  }
}


#Route Table for public subnet
resource "aws_route_table" "rt_sub_public" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw_main.id
  }

  tags = {
    Name = "public-route-table"
  }
}

#Route Table Association for public subnet
resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.rt_sub_public.id
}


#Route Table for private subnet
resource "aws_route_table" "rt_sub_private" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "private-route-tableT"
  }
}

#Route Table Association for privat subnet
resource "aws_route_table_association" "private_assoc" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.rt_sub_private.id
}